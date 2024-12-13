provider "aws" {
  region = "us-east-1"
}

# Security Group to allow inbound HTTP, TCP, and SSH traffic
resource "aws_security_group" "docker_sg" {
  name        = "allow_http_tcp_ssh"
  description = "Allow HTTP, custom TCP, and SSH inbound traffic"

  # Allow inbound HTTP traffic on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound traffic on port 5000 (for Flask)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH inbound traffic on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "docker_security_group"
  }
}

# EC2 instance configuration without key pair
resource "aws_instance" "dockerinstace" {
  ami                    = "ami-0ae8f15ae66fe8cda"
  instance_type          = "t2.micro"
  user_data              = file("provisioning.sh")
  vpc_security_group_ids = [aws_security_group.docker_sg.id]
  tags = {
    "Name" = "Braintumordockerinstace"
  }
}

# Elastic IP (optional but recommended for a static public IP)
resource "aws_eip" "docker_eip" {
  instance = aws_instance.dockerinstace.id
  domain   = "vpc"
}

# Outputs
output "instance_public_ip" {
  value = aws_eip.docker_eip.public_ip
}

output "instance_public_dns" {
  value = aws_instance.dockerinstace.public_dns
}
