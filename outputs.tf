output "s3_bucket_name" {
  value = aws_s3_bucket.demo.bucket
}

output "ec2_public_ip" {
  value = aws_instance.demo.public_ip
}