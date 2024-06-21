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

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}
