#!/usr/bin/env groovy

properties([
    buildDiscarder(
        logRotator(
            numToKeepStr: '10',
            artifactNumToKeepStr: '1'
        )
    )
])

def DOCKER_REGISTRY = 'docker-registry.agilefabric.fr.carrefour.com'
def DOCKER_IMAGE    = "${DOCKER_REGISTRY}/redlinc/redlinc-app-webapp"
def NEXUS_URL       = 'https://nexus.agilefabric.fr.carrefour.com/repository/redlinc_charts'
//def DEPLOY_JOB      = 'RedlinC/job/deploy-redlinc-jhi-c4/master'
def COMMIT_ID
def APP_VERSION


def globalNpmrcConfigId= 'b50a94d8-f641-48ba-b123-0caa1e3b47c9'

node('ci-slave-docker') {

    def generatedAppImage = null

    try {
        checkoutWithTags()
        def jenkinsUserAndGroup = sh(script: 'echo "$(id -u):$(id -g)"', returnStdout: true).trim()

        docker.image('jhipster/jhipster:v6.3.0').inside('-u root -e MAVEN_OPTS="-Duser.home=./" -v /datas/maven/repo:/datas/maven/repo') {
            try {
                def pom
                stage('Build & Tests') {
                    withMaven(mavenSettingsConfig: 'AF_MavenSettings') {

                        pom = readMavenPom file: 'pom.xml'

                        COMMIT_ID = getShortCommitId()
                        APP_VERSION = getAppVersion(pom.version, COMMIT_ID, getGitCurrentVersionTag())
                        pom.setVersion(APP_VERSION)
                        writeMavenPom model: pom

                        withNPM(npmrcConfig: globalNpmrcConfigId) {
                            sh 'chmod +x ./mvnw'
                            sh './mvnw clean verify -Pprod'
                        }
                    }
                }

                if (env.BRANCH_NAME == 'develop' || isPullRequest()) {
                    stage('Sonar analysis') {
                        withMaven(mavenSettingsConfig: 'AF_MavenSettings') {
                            withSonarQubeEnv('Sonar Agile Fabric') {
                                def sonarProperties = ''
                                if (env.BRANCH_NAME != 'develop') {
                                    sonarProperties = "-Dsonar.projectKey=\'${pom.groupId}:${pom.artifactId}-SNAPSHOT\' -Dsonar.projectName=\'${pom.name} - SNAPSHOT\'"
                                }
                                sh "./mvnw initialize sonar:sonar ${sonarProperties}"
                            }
                        }
                    }
                    stage('Quality gate') {
                        withSonarQubeEnv('Sonar Agile Fabric') {
                            timeout(time: 1, unit: 'HOURS') {
                                waitForQualityGate abortPipeline: true
                            }
                        }
                    }
                }
            } finally {
                sh "chown -R ${jenkinsUserAndGroup} ."
                junit '**/target/test-results/test/TEST-*.xml'
            }
        }

        stage('Docker - Build image') {
            sh "cp -R src/main/docker/* target/"
            generatedAppImage = docker.build("${DOCKER_IMAGE}:${COMMIT_ID}", 'target/')
        }

        if (shouldPublishApp()) {
            stage('Docker - Push image') {
                docker.withRegistry("https://${DOCKER_REGISTRY}", 'portus-credentials') {
                    generatedAppImage.push()
                    generatedAppImage.push(APP_VERSION)
                }
            }
        }

        if (shouldPublishApp()) {
            stage ('Helm - Package & publish chart') {
                withCredentials([usernamePassword(credentialsId: 'portus-credentials', passwordVariable: 'PORTUS_PASSWORD', usernameVariable: 'PORTUS_USERNAME')]) {
                    sh "docker login -u ${PORTUS_USERNAME} -p ${PORTUS_PASSWORD} ${DOCKER_REGISTRY}"
                }
                docker.image('docker-registry.agilefabric.fr.carrefour.com/jhipster-c4/tools/helm-kubectl:v2.16.0').inside() {
                    dir ("${WORKSPACE}") {
                        sh "mkdir -p ${WORKSPACE}/repository-charts"
                        sh "helm init --client-only --home ${WORKSPACE}"
                        sh "sed -i -e 's/version:.*/version: ${APP_VERSION}/' chart/redlinc-app-webapp/Chart.yaml"
                        sh "sed -i -e 's/appVersion:.*/appVersion: ${APP_VERSION}/' chart/redlinc-app-webapp/Chart.yaml"
                        sh "helm package chart/redlinc-app-webapp/ --home ${WORKSPACE} --destination ${WORKSPACE}/repository-charts"
                        sh "helm repo index repository-charts --url ${NEXUS_URL} --home ${WORKSPACE} --merge ${WORKSPACE}/repository-charts/index.yaml"
                        withCredentials([
                            usernamePassword(credentialsId: 'nexus-cred-helm', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_USERNAME')]){
                            sh "curl -k -u ${NEXUS_USERNAME}:${NEXUS_PASSWORD} --upload-file ${WORKSPACE}/repository-charts/redlinc-app-webapp-${APP_VERSION}.tgz  ${NEXUS_URL}/redlinc-app-webapp-${APP_VERSION}.tgz"
                        }
                    }
                }
            }
            /*if (env.BRANCH_NAME == 'develop') {
                stage ('Continuous Deployment - Deploying - SNAPSHOT'){
                    build job: DEPLOY_JOB, quietPeriod: 1, wait: false, parameters: [
                        [$class: 'StringParameterValue', name: 'APP_NAME', value: 'redlinc-app-webapp'],
                        [$class: 'StringParameterValue', name: 'APP_VERSION', value: "${APP_VERSION}"],
                        [$class: 'StringParameterValue', name: 'APP_ENV', value: 'dev']
                    ]
                }
            }*/
        }
    } finally {
        // remove generated image on node
        if (generatedAppImage && generatedAppImage.id) {
            sh "docker rmi -f \$(docker images -q ${generatedAppImage.id})"
        }
        cleanWs(patterns:[
            [pattern:'node_modules/**', type:'EXCLUDE'],
            [pattern:'node/**', type:'EXCLUDE']
        ], deleteDirs: true)
    }
}


def checkoutWithTags() {
     checkout([
        $class: 'GitSCM',
        branches: [[name: 'refs/heads/'+env.BRANCH_NAME]],
        extensions: [[$class: 'CloneOption', noTags: false, shallow: false, depth: 0, reference: '']],
        userRemoteConfigs: scm.userRemoteConfigs,
    ])
}

def getShortCommitId() {
    return sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
}

def shouldPublishApp() {
    def shouldPublish =  env.BRANCH_NAME == 'develop' || env.BRANCH_NAME.startsWith('release/') || env.BRANCH_NAME.startsWith('hotfix/')
    return shouldPublish
}

def getAppVersion(pomVersion, commiId, gitVersionTag) {
    def appVersion = "${pomVersion}-${commiId}"
    if (env.BRANCH_NAME.startsWith('release/') || env.BRANCH_NAME.startsWith('hotfix/')) {
        if(gitVersionTag != null && !gitVersionTag.isEmpty()) {
            appVersion = pomVersion
        } else {
            appVersion = "${pomVersion}-rc.${env.BUILD_NUMBER}"
        }
    }
    return appVersion
}

def getGitCurrentVersionTag() {
    def tag = sh(script: 'git describe --tags --exact-match || echo "noTag"', returnStdout: true).trim()
    if (tag ==~ /v[\d\.]+/) {
        return tag
    }
    return null
}

def isPullRequest() {
    return env.CHANGE_ID != null
}

def isMergeRequest() {
    return env.CHANGE_ID != null
}

def isTag() {
    return env.CHANGE_ID != null
}

def isPullMerged() {
    return env.CHANGE_ID != sh('script: git desribe --latest')
}

read.class.destroy();

read.class.clean();

read.class.rebuild();

read.class.clean();