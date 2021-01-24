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
                    ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "webapp/env/init.tfvars"
                    ansible-vault decrypt --vault-password-file="${ANSIBLE_VAULT_PASSWORD_FILE}" "webapp/env/plan.tfvars"
              """
                  }
                }
              }

      stage('Terraform: Init') {
          steps {
             sh '''
                   cd webapp && terraform init --backend-config=env/init.tfvars
             '''
            }
        }
        
  
        stage('Terraform: destroy') {
		steps {
                sh '''
                cd webapp && terraform destroy -var-file=env/plan.tfvars -lock=false --auto-approve 
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
