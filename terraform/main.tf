# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    backend "s3" {
      bucket         = "myappbucket99"  # Replace with your actual bucket name
      key            = "myappbucket99/terraform.tfstate"  # Path to your state file within the bucket
      region         = "us-east-1"  # AWS region where your bucket is located
      #dynamodb_table = "terraform-locks"  # (Optional) DynamoDB table for state locking
      encrypt        = true  # Encrypt state at rest
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
  #profile = "terraadmin"
}




# Data source to retrieve information about the default VPC
data "aws_vpc" "default" {
  default = true
}


data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}



# Create a new security group allowing HTTP and HTTPS traffic
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-sg"
  description = "Security group for Lambda function allowing HTTP and HTTPS traffic"
  vpc_id      = data.aws_vpc.default.id

  # Inbound rule to allow HTTP traffic
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound rule to allow HTTPS traffic
  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule to allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-sg"
  }
}

# Define any other global resources or modules
