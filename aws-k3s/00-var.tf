variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-2" # London
}

variable "ami_id" {
  type        = string
  description = "Ubuntu AMI ID"
  default = "ami-0a94c8e4ca2674d5a"
}


variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
}

resource "aws_key_pair" "ansible_host" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro" # Free tier
}


variable "worker_count" {
  description = "Number of worker nodes"
  default     = 2
}