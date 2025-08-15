##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  # key_name               = "test"  # Make sure you have this key pair in your AWS account

  user_data = <<EOF
#!/bin/bash
# Update system packages
sudo yum update -y

# Install Nginx
sudo amazon-linux-extras install -y nginx1

# Make sure Nginx starts at boot
sudo systemctl enable nginx

# Start Nginx
sudo systemctl start nginx

# Check if Nginx is running correctly
sudo systemctl status nginx

# Create custom index page
sudo rm -f /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server 1</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html

# Log the output for troubleshooting
echo "Nginx installation complete" >> /var/log/user-data.log
EOF

  # Add this if you want to add tags
  tags = {
    Name = "nginx-server"
  }
}



resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  # key_name               = "test"  # Make sure you have this key pair in your AWS account

  user_data = <<EOF
#!/bin/bash
# Update system packages
sudo yum update -y

# Install Nginx
sudo amazon-linux-extras install -y nginx1

# Make sure Nginx starts at boot
sudo systemctl enable nginx

# Start Nginx
sudo systemctl start nginx

# Check if Nginx is running correctly
sudo systemctl status nginx

# Create custom index page
sudo rm -f /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server 2</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html

# Log the output for troubleshooting
echo "Nginx installation complete" >> /var/log/user-data.log
EOF

  # Add this if you want to add tags
  tags = {
    Name = "nginx-server"
  }
}