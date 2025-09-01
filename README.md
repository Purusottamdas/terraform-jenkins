# terraform-jenkins

Step 1: Plan Your Architecture

We’ll keep it simple for now:

An EC2 instance running Jenkins.

Terraform code stored in GitHub.

Jenkins pipeline pulls code → runs Terraform → provisions AWS infra (example: create an S3 bucket + EC2).

Step 2: Create IAM Role and Permissions

Go to IAM → Roles → Create Role.

Choose EC2 as trusted entity.

Attach policy: AdministratorAccess (for learning; later you can restrict).

Name it: TerraformPipelineRole.

Attach this role to your Jenkins EC2.

Step 3: Launch EC2 for Jenkins

Launch Amazon Linux 2023 / Ubuntu 22.04 instance (t2.micro).

Attach the IAM Role (TerraformPipelineRole).

Security Group:

SSH (22) → your IP.

HTTP (80) → Anywhere.

Custom TCP (8080) → Anywhere (for Jenkins).

Step 4: Install Jenkins + Terraform on EC2

SSH into EC2 and run:

# Update system
sudo yum update -y

# Install Java (Jenkins dependency)
sudo amazon-linux-extras install java-openjdk11 -y

# Add Jenkins repo and install
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo curl -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo yum install jenkins -y

# Start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Install Git
sudo yum install git -y

# Install Terraform
curl -fsSL https://releases.hashicorp.com/terraform/1.9.5/terraform_1.9.5_linux_amd64.zip -o terraform.zip
sudo unzip terraform.zip -d /usr/local/bin/
terraform -v


Now Jenkins is running at:
http://<EC2-Public-IP>:8080

Step 5: GitHub Repo Setup

Structure your repo like this:

terraform-jenkins-demo/
 ├── main.tf
 ├── variables.tf
 ├── outputs.tf
 └── Jenkinsfile


Example main.tf (creates S3 bucket + EC2):

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "demo" {
  bucket = "my-demo-bucket-123456"
}

resource "aws_instance" "demo_ec2" {
  ami           = "ami-08e5424edfe926b43" # Amazon Linux 2023 (update as needed)
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform-Demo"
  }
}

Step 6: Jenkins Setup

Unlock Jenkins (use /var/lib/jenkins/secrets/initialAdminPassword).

Install Pipeline + GitHub plugins.

Configure Jenkins credentials for GitHub (if repo is private).

Step 7: Jenkinsfile (Pipeline Script)

Place this in your repo:

pipeline {
    agent any

    environment {
        AWS_REGION = "ap-south-1"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/<your-username>/terraform-jenkins-demo.git'
            }
        }

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
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}

Step 8: Run Pipeline

Create a new Pipeline job in Jenkins.

Point it to your GitHub repo.

Run build → Terraform will provision resources.

Step 9: (Optional Best Practices)

Use S3 backend + DynamoDB for Terraform state.

Use GitHub Webhooks (or Poll SCM) to trigger automatically.

Lock down security group (don’t keep 0.0.0.0/0 in production).