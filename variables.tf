variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "private_subnets" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}
