# Brain Tumor Detection Flask Application

This project involves deploying a Dockerized Flask application for brain tumor detection using a custom-trained machine learning model. The application is deployed on an AWS EC2 instance, with traffic load balancing achieved through Nginx and container orchestration using Docker Compose. The infrastructure setup is managed using Terraform, which provisions the necessary security group, Elastic IP, and EC2 instance.

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Setup](#setup)
  - [Docker Configuration](#docker-configuration)
  - [Nginx Configuration](#nginx-configuration)
  - [Terraform Configuration](#terraform-configuration)
- [Deployment](#deployment)
- [Usage](#usage)
- [Cleanup](#cleanup)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

This application uses a machine learning model to detect brain tumors from MRI images. It is built using Flask and Dockerized for easy deployment. The application is configured to run multiple containers with an Nginx load balancer for handling traffic distribution across replicas, ensuring high availability and scalability.

## Architecture

1. **Docker**: Containerizes the Flask application and runs multiple replicas.
2. **Docker Compose**: Manages multi-container Docker applications and sets up the Nginx load balancer.
3. **Nginx**: Acts as a reverse proxy and load balancer to distribute incoming traffic among replicated Flask application containers.
4. **Terraform**: Automates the provisioning of AWS resources including EC2, Security Groups, and Elastic IPs.
5. **AWS EC2**: Hosts the Dockerized application.

## Prerequisites

Ensure you have the following installed on your local machine:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Terraform](https://www.terraform.io/downloads)
- AWS account with the necessary permissions to create EC2 instances, security groups, and Elastic IPs.

## Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/brain-tumor-detection-flask-app.git
   cd brain-tumor-detection-flask-app
   ```

## AWS Credentials Configuration

Before running Terraform, you need to configure your AWS credentials so that Terraform can access your AWS account to provision resources.

1. **Configure AWS Credentials**

   AWS credentials can be set up using the AWS CLI. Run the following command and enter your AWS Access Key ID, Secret Access Key, region, and output format when prompted:

   ```bash
   aws configure
   ```

   Alternatively, you can set up the credentials manually by creating a file at `~/.aws/credentials` (Linux & Mac) or `%USERPROFILE%\.aws\credentials` (Windows) with the following content:

   ```
   [default]
   aws_access_key_id = YOUR_ACCESS_KEY_ID
   aws_secret_access_key = YOUR_SECRET_ACCESS_KEY
   region = YOUR_AWS_REGION
   ```

   Replace `YOUR_ACCESS_KEY_ID`, `YOUR_SECRET_ACCESS_KEY`, and `YOUR_AWS_REGION` with your actual AWS credentials and preferred region.

## Setup

### Docker Configuration

1. **Dockerfile**

   The Dockerfile sets up the Flask application with all necessary dependencies. It uses Python 3.10 as the base image and installs the required libraries specified in `requirements.txt`.

2. **docker-compose.yml**

   The Docker Compose file defines the services, including the Flask application and Nginx. It replicates the Flask service and connects it to the Nginx service, which is configured as a load balancer.

### Nginx Configuration

1. **nginx.conf**

   The Nginx configuration file defines the upstream servers and load balancing strategy. It balances traffic among the Flask application containers.

### Terraform Configuration

1. **main.tf**

   The Terraform configuration sets up the required AWS resources:

   - **Security Group**: Allows traffic on HTTP (port 80) and SSH (port 22).
   - **Elastic IP**: Provides a static public IP for the EC2 instance.
   - **EC2 Instance**: Hosts the Dockerized application.

2. **provisioning.sh**

   The Bash script to be executed by the Terraform file provisioner to set up Docker and Docker Compose on the EC2 instance, and then run the Docker Compose setup.

## Deployment

1. **Run Terraform**

   Navigate to the Terraform configuration directory and run:

   ```bash
   terraform init
   terraform apply
   ```

   Confirm the apply operation and wait for Terraform to provision the infrastructure.

2. **Access the Application**

   After Terraform completes, the application will be accessible via the public IP provided by the Elastic IP. You can access it in your browser using:

   ```
   http://<your-elastic-ip>
   ```

## Usage

- Upload MRI images through the Flask application interface.
- The application will predict and display whether a brain tumor is detected based on the input image.

## Cleanup

To clean up the resources provisioned by Terraform, run:

```bash
terraform destroy
```

This command will terminate the EC2 instance, release the Elastic IP, and remove the security group.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss improvements, new features, or bugs.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Feel free to customize this README with specific details such as repository links, your AWS region, and other unique configurations related to your setup!
