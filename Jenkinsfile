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
        stage('Terraform Plan') {
            steps{
                script{
                    sh 'terraform plan -out $BUILD_NUMBER.tfplan'
                }
            }    
        }
        stage('Terraform Apply') {
            steps{
                script{
                    sh 'terraform apply $BUILD_NUMBER.tfplan'
                }
            }
        }
        
        
    }
}