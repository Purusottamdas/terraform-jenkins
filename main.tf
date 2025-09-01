/*terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}*/

provider "aws" {
  region = var.aws_region
}

# --------------------------
# S3 Bucket
# --------------------------
resource "aws_s3_bucket" "demo" {
  bucket = var.s3_bucket_name
  tags = {
    Name        = "DemoBucket"
    Environment = "Dev"
  }
}

# --------------------------
# EC2 Instance
# --------------------------
resource "aws_instance" "demo" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  tags = {
    Name = "DemoEC2"
  }
}
