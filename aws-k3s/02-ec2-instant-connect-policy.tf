# IAM Role for EC2 Instance Connect only
resource "aws_iam_role" "ec2_role" {
  name = "k3s-ec2-connect-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach EC2 Instance Connect policy
resource "aws_iam_role_policy_attachment" "ec2_connect_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceConnect"
}

# Attach SSM ManagedInstanceCore policy
resource "aws_iam_role_policy_attachment" "ssm_core_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "k3s-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}