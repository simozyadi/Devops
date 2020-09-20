pipeline {
    
    agent none

     environment {

      ANSIBLE_VAULT_PASSWORD_FILE = "./vault.txt"

    }
  
    stages {

        stage('Ansible: Decrypt Files') {
     agent   {  

        docker {

	    image 'ansible/ansible:ubuntu1404'
	    label 'cdnode'
	    args "-u root:root --entrypoint='' --network host"

        }

    } 

         steps{
           withCredentials([string(credentialsId: 'AnsibleVault', variable: 'PASS')]) {
              sh """
                    echo $PASS > ./vault.txt
 	                ls && pwd
                    ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "./vm/env/init.tfvars"
                    ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "./vm/env//plan.tfvars"
              """
                  }
                }
              }

        stage('Terraform: Init') {
            steps {
                sh '''
               echo  terraform init --backend-config=init.tfvars
                '''
            }
        }
        
        stage('Terraform: Plan') {
            steps {
                sh '''
              echo  terraform plan -var-file=plan.tfvars -out=${BUILD_NUMBER}.tfplan
                '''
            }
        }
        
        stage('Terraform: Apply') {
            steps {
                sh '''
               echo terraform init ${BUILD_NUMBER}.tfplan --auto-approve
                '''
            }
        }
        
    }
            post {
                always {
                  step([$class: 'WsCleanup'])
                }
            }
}
