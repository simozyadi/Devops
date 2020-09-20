pipeline {
    
       agent   {  

        docker {

	    //image 'xakra/ansible-dockerized'
         image 'siticom/terraform-ansible'
	    label 'cdnode'
	    args "-u root:root --entrypoint='' --network host"

        }

    } 

     environment {

      ANSIBLE_VAULT_PASSWORD_FILE = "./vault.txt"

    }
  
    stages {

        stage('Ansible: Decrypt Files') {
 

         steps{
           withCredentials([string(credentialsId: 'AnsibleVault', variable: 'PASS')]) {
              sh """
                    echo $PASS > ./vault.txt
 	                ls && pwd
                     echo before cat
                     cat ./vault.txt
                     echo after cat
                     ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "./vm/env/init.tfvars"
                     ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "./vm/env/plan.tfvars"
              """
                  }
                }
              }

        stage('Terraform: Init') {

            steps {
                sh '''
                ls && pwd
                terraform init --backend-config=vm/env/init.tfvars
                '''
            }
        }
        
        stage('Terraform: Plan') {

            steps {
                sh '''
                ls && pwd && terraform plan -var-file=./vm/env/plan.tfvars -out=${BUILD_NUMBER}.tfplan
                '''
            }
        }
        
        stage('Terraform: Apply') {

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
