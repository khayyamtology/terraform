variable "cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "repository_url" {
  description = "The URL of the ECR repository"
  type        = string
}
