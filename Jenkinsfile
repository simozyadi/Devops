pipeline {
    
    agent {
        docker {
            image 'siticom/terraform-ansible'
	        label 'master'
	        args "-u root:root --entrypoint='' --network host"
        }
    }
    
    stages {
        

        stage('Terraform Init') {
            steps{
                script{
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Destroy') {
            steps{
                script{
                    sh 'terraform destroy --auto-approve'
                }
            }
        }
        
        
    }
}