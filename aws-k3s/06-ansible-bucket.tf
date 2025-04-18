# s3-bucket.tf
resource "aws_s3_bucket" "ansible_ssm_bucket" {
  bucket = "ansible-ssm-bucket-${random_string.suffix.result}"
  force_destroy = true
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
}

resource "aws_s3_bucket_ownership_controls" "ansible_ssm_bucket" {
  bucket = aws_s3_bucket.ansible_ssm_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "ansible_ssm_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.ansible_ssm_bucket]
  bucket = aws_s3_bucket.ansible_ssm_bucket.id
  acl    = "private"
}

# 输出桶名称供 Ansible 使用
output "s3_bucket_name" {
  value = aws_s3_bucket.ansible_ssm_bucket.id
}