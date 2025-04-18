
# EC2 Instance
resource "aws_instance" "k3s_master" {
  # Add explicit dependencies
  depends_on = [
    aws_vpc.main,
    aws_subnet.public,
    aws_internet_gateway.igw,
    aws_route_table.public,
    aws_route_table_association.public,
    aws_iam_instance_profile.ec2_profile,
    aws_security_group.instance_sg,
  ]

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ansible_host.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size = 8 # Stay within free tier
    volume_type = "gp3" # Use gp2 instead of gp3 to ensure free tier eligibility
  }

  user_data = <<-EOF
    #!/bin/bash
    # EC2 user_data script
    
    # Install EC2 Instance Connect
    apt-get update -y
    apt-get install -y ec2-instance-connect
    
    systemctl enable ec2-instance-connect
    systemctl start ec2-instance-connect

    # Install EC2 SSM Agent
    snap install amazon-ssm-agent --classic
    systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent
    systemctl start snap.amazon-ssm-agent.amazon-ssm-agent
    
    # Update the system and install necessary packages
    apt-get update -y
    apt-get install -y apt-transport-https ca-certificates curl
    
    # Create a status file for easy checking
    echo "Setup completed at $(date)" > /home/ubuntu/setup_complete.txt
  EOF

  tags = {
    Name = "k3s-Master"
    Environment = "Dev"
  }
}


resource "aws_instance" "k3s_worker" {
  count         = var.worker_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ansible_host.key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size = 8 # Stay within free tier
    volume_type = "gp3" # Use gp2 instead of gp3 to ensure free tier eligibility
  }

  user_data = <<-EOF
    #!/bin/bash
    # EC2 user_data script
    
    # Install EC2 Instance Connect
    apt-get update -y
    apt-get install -y ec2-instance-connect
    
    systemctl enable ec2-instance-connect
    systemctl start ec2-instance-connect
    
    # Install EC2 SSM Agent
    snap install amazon-ssm-agent --classic
    systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent
    systemctl start snap.amazon-ssm-agent.amazon-ssm-agent

    # Update the system and install necessary packages
    apt-get update -y
    apt-get install -y apt-transport-https ca-certificates curl
    
    # Create a status file for easy checking
    echo "Setup completed at $(date)" > /home/ubuntu/setup_complete.txt
  EOF

  tags = {
    Name = "k3s-Worker-${count.index}"
    Environment = "Dev"
  }
}