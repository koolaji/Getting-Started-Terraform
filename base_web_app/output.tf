# Output the public IP and DNS for easy access
output "instance_ip" {
  value = aws_instance.nginx1.public_ip
}

output "instance_dns" {
  value = aws_instance.nginx1.public_dns
}
