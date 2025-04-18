resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl", {
    master_ip      = aws_instance.k3s_master.public_ip
    master_private = aws_instance.k3s_master.private_ip
    worker_ips     = aws_instance.k3s_worker.*.public_ip
    worker_privates = aws_instance.k3s_worker.*.private_ip
    master_id      = aws_instance.k3s_master.id
    worker_ids     = aws_instance.k3s_worker.*.id
    bucket_name   = aws_s3_bucket.ansible_ssm_bucket.bucket
  })
  filename = "inventory.ini"
}