#!/bin/bash

# Update the system packages
sudo yum update -y

# Install Docker
sudo yum install docker -y

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create a directory for the project
mkdir -p ~/brain_tumor_detection_app
cd ~/brain_tumor_detection_app

# Create Docker Compose file
cat > docker-compose.yml << EOF
version: '3'

services:
  web:
    image: aryansin1315/brain_tumor_detection_app:latest
    deploy:
      replicas: 1
    expose:
      - "5000"

  nginx:
    image: nginx:latest
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    ports:
      - "80:80"
    depends_on:
      - web

networks:
  default:
    driver: bridge
EOF

# Create Nginx configuration file
cat > nginx.conf << EOF
events {
    worker_connections 1000;
}

http {
    upstream flask_app {
        server web:5000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://flask_app;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
    }
}
EOF

# Run Docker Compose
sudo docker-compose up -d

# Print the public IP address
echo "Your application is now accessible at http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"