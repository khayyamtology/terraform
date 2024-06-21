# main.tf

# terraform {
#   backend "s3" {
#     bucket         = "kk-terraform-state-bucket"
#     key            = "terraform/state"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-lock-table"
#     encrypt        = true
#   }
# }

provider "aws" {
  region = "us-east-1" 
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name           = "kk-custom-vpc"
  cidr_block         = "10.163.10.0/24"
  private_subnets    = ["10.163.10.0/26", "10.163.10.64/26"]
  enable_nat_gateway = false
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = "kk-sample-repo"
}

module "ecs_cluster" {
  source = "./modules/ecs_cluster"

  cluster_name       = "kk-ecs-cluster"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  repository_url     = module.ecr.repository_url
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_id" {
  value = module.ecs_cluster.cluster_id
}

# To ensure that ECS cluster deletion happens before VPC deletion
resource "null_resource" "cleanup" {
  depends_on = [
    module.ecs_cluster,
  ]

  provisioner "local-exec" {
    command = "echo 'Clean up complete'"
  }
}
