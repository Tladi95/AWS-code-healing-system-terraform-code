terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "af-south-1"
 
  assume_role {
    role_arn = "arn:aws:iam::432049653324:role/TerraformRole"
    }
}
#VPC resources
resource "aws_vpc" "code-healing-vpc" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_internet_gateway" "code-healing-igw" {
  vpc_id = aws_vpc.code-healing-vpc.id
}
resource "aws_route_table" "code-healing-route-table" {
  vpc_id = aws_vpc.code-healing-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.code-healing-igw.id
  }
}
resource "aws_subnet" "code-healing-subnet" {
  vpc_id            = aws_vpc.code-healing-vpc.id
  availability_zone = "af-south-1a"
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
}
resource "aws_route_table_association" "code-healing-rt-association" {
  subnet_id      = aws_subnet.code-healing-subnet.id
  route_table_id = aws_route_table.code-healing-route-table.id
}

resource "aws_security_group" "code-healing-sg" {
  name        = "code-healing-sg"
  description = "Security group for Code Healing"
  vpc_id      = aws_vpc.code-healing-vpc.id


  ingress {
    description = "Application Port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#ECS configs
resource "aws_ecs_cluster" "code-healing-cluster" {
  name = "code-healing-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}