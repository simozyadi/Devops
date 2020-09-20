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


     stage('Ansible: Decrypt Files') {
         steps{
           withCredentials([string(credentialsId: 'AnsibleVault', variable: 'PASS')]) {
              sh """
      		echo $PASS > ./vault.txt
 	            ls && pwd
                    ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "vm/env/init.tfvars"
                    ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "vm/env/plan.tfvars"
              """
                  }
                }
              }

      
        
      
        
        stage('Terraform: destroy') {
		steps {
                sh '''
                cd vm && terraform destroy  -var-file=env/init.tfvars -var-file=env/plan.tfvars --auto-approve
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