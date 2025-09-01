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
