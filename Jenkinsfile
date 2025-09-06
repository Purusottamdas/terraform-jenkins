pipeline {
    agent any

    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Choose whether to create (apply) or delete (destroy) infrastructure'
        )
    }

    environment {
        AWS_REGION = "ap-south-1"
    }

    stages {
        stage('Checkout') {
        /* steps {
                git branch: 'main', url: 'https://github.com/Purusottamdas/terraform-jenkins.git'
            }
        }*/

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    if (params.ACTION == 'apply') {
                        sh 'terraform plan -out=tfplan'
                    } else {
                        sh 'terraform plan -destroy -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Execute') {
            steps {
                script {
                    if (params.ACTION == 'apply') {
                        sh 'terraform apply -auto-approve tfplan'
                    } else {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}
