# Output the public IP and DNS for easy access
output "instance_ip" {
  value = aws_instance.nginx1.public_ip
}

output "instance_dns" {
  value = aws_instance.nginx1.public_dns
}


output "aws_instance_public_dns" {
  value = "http://${aws_instance.nginx1.public_dns}"
}


output "aws_alb_public_dns" {
  value = "http://${aws_lb.nginx.dns_name}"
}
