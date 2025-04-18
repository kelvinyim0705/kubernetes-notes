output "master_public_ip" {
  value = aws_instance.k3s_master.public_ip
}

output "worker_public_ips" {
  value = aws_instance.k3s_worker.*.public_ip
}

output "master_private_ip" {
  value = aws_instance.k3s_master.private_ip
}

output "worker_private_ips" {
  value = aws_instance.k3s_worker.*.private_ip
}

output "ssh_key_name" {
  value = aws_key_pair.ansible_host.public_key
} 