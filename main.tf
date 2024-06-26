provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block
  private_subnets = var.private_subnets
  region = var.region
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = var.repository_name
}

resource "null_resource" "build_and_push_docker_image" {
  provisioner "local-exec" {
    command = "./build_and_push.sh ${module.ecr.repository_url} ${var.region}"
    environment = {
      AWS_PROFILE = "default"
    }
  }

  depends_on = [module.ecr]
}

module "ecs_cluster" {
  source = "./modules/ecs_cluster"
  cluster_name       = var.cluster_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  repository_url     = "${module.ecr.repository_url}:latest"
  ecs_security_group = module.vpc.security_group_ids.ecs
  region             = var.region
  depends_on         = [null_resource.build_and_push_docker_image]
}
