pipeline {
    
    agent any

     environment {

      ANSIBLE_VAULT_PASSWORD_FILE = "./vault.txt"

    }
  
    stages {

        stage('Ansible: Decrypt Files') {
     agent   {  

        docker {

	    //image 'xakra/ansible-dockerized'
         image 'virtualhold/ansible-vault:latest'
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

                    agent   {  

        docker {

         image 'terraformdocker/terraform:latest'
	    label 'cdnode'
	    args "-u root:root --entrypoint='' --network host"

        }

    } 
            steps {
                sh '''
                terraform init --backend-config=init.tfvars
                '''
            }
        }
        
        stage('Terraform: Plan') {

           agent   {  

        docker {

         image 'terraformdocker/terraform:latest'
	    label 'cdnode'
	    args "-u root:root --entrypoint='' --network host"

        }

    } 
            steps {
                sh '''
                terraform plan -var-file=plan.tfvars -out=${BUILD_NUMBER}.tfplan
                '''
            }
        }
        
        stage('Terraform: Apply') {

                    agent   {  

        docker {

         image 'terraformdocker/terraform:latest'
	    label 'cdnode'
	    args "-u root:root --entrypoint='' --network host"

        }

    } 
            steps {
                sh '''
                terraform Apply ${BUILD_NUMBER}.tfplan --auto-approve
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
