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
                   cd aks/resources/ && terraform init --backend-config=env/init.tfvars
             '''
            }
        }
        
      stage('Terraform: Plan') {
  	steps {
                sh '''
                cd aks/resources/ && terraform plan -var-file=env/plan.tfvars -out=${BUILD_NUMBER}.tfplan
                '''
            }
        }
        
        stage('Terraform: Apply') {
		steps {
                sh '''
                cd && aks/resources/ terraform apply ${BUILD_NUMBER}.tfplan --auto-approve
                '''
            }
        }
        stage('Terraform: Destroy') {
		steps {
                sh '''
                cd aks/resources/ && terraform destroy -var-file=env/init.tfvars -var-file=env/plan.tfvars --auto-approve
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
