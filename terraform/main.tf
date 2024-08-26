# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

# Data source to retrieve information about the default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to retrieve information about default subnets
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Data source to retrieve the default security group
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

# Define any other global resources or modules
