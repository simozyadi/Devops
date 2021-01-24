pipeline {

    environment {

      ANSIBLE_VAULT_PASSWORD_FILE = "./vault.txt"

    }


   agent   {  

        docker {

	    image 'siticom/terraform-ansible'
	    label 'master'
	    args "-u root:root --entrypoint='' --network host"

        }

    } 
    stages {


     stage('Ansible: Decrypt Files') {
         steps{
           withCredentials([string(credentialsId: 'AnsibleVault', variable: 'PASS')]) {
              sh """
      		echo $PASS > ./vault.txt
 	            ls && pwd
                    ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "bgwebapp/env/init.tfvars"
                    ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "bgwebapp/env/plan.tfvars"
              """
                  }
                }
              }

      stage('Terraform: Init') {
          steps {
             sh '''
                   cd bgwebapp && terraform init --backend-config=env/init.tfvars
             '''
            }
        }
        
        
        stage('Terraform: Destroy') {
		      steps {
                sh '''
                cd bgwebapp && terraform destroy -var-file=env/plan.tfvars --auto-approve
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
