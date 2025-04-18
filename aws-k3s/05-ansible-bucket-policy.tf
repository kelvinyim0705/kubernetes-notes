# 在 ec2-instant-connect-policy.tf 中添加
resource "aws_iam_policy" "s3_access_policy" {
  name        = "k3s-s3-access-policy"
  description = "Policy for S3 access for SSM sessions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetBucketLocation"
        ],
        Effect   = "Allow",
        Resource = [
          "${aws_s3_bucket.ansible_ssm_bucket.arn}",
          "${aws_s3_bucket.ansible_ssm_bucket.arn}/*"
        ]
      }
    ]
  })
}

# 附加 S3 访问策略
resource "aws_iam_role_policy_attachment" "s3_access_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}