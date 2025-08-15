##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
resource "aws_vpc" "app" {
  cidr_block           = var.aws_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = local.common_tags
}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id
  tags = local.common_tags
}

resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.aws_vpc_subnet
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.aws_map_public_ip_on_launch
  availability_zone       = var.aws_region
  tags = local.common_tags
}

# ROUTING #
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.app.id
  tags = local.common_tags
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere (add this for troubleshooting)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
echo '<html><head><title>Taco Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html

# Log the output for troubleshooting
echo "Nginx installation complete" >> /var/log/user-data.log
EOF

  # Add this if you want to add tags
  tags = {
    Name = "nginx-server"
  }
}

