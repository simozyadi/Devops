pipeline {

    environment {

      ANSIBLE_VAULT_PASSWORD_FILE = "./vault.txt"

    }


   agent   {  

        docker {

	    image 'siticom/terraform-ansible'
	    label 'cdnode'
	    args "-u root:root --entrypoint='' --network host"

        }

    } 
    stages {

      stage('Jenkins: Determine Operations'){
        steps {
          script {
                   def operation = "deploy"  
                 }
                }
              }

     stage('Ansible: Decrypt Files') {
         steps{
           withCredentials([string(credentialsId: 'AnsibleVault', variable: 'PASS')]) {
              sh """
			echo $PASS > ./vault.txt
 	            ls && pwd
                    ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "aks/resources/env/init.tfvars"
                    ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "aks/resources/env/plan.tfvars"

              """
                  }
                }
              }

      stage('Terraform: Init') {
          steps {
             sh '''
                   terraform init --backend-config=aks/resources/env/init.tfvars
             '''
            }
        }
        
      stage('Terraform: Plan') {
  	steps {
                sh '''
                terraform plan -var-file=aks/resources/env/plan.tfvars -out=${BUILD_NUMBER}.tfplan
                '''
            }
        }
        
        stage('Terraform: Apply') {
		steps {
                sh '''
                terraform init ${BUILD_NUMBER}.tfplan --auto-approve
                '''
            }
        }
        stage('Terraform: Destroy') {
		steps {
                sh '''
                terraform destroy -var-file=aks/resources/env/init.tfvars -var-file=aks/resources/plan.tfvars --auto-approve
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
