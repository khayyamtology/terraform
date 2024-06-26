output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_id" {
  value = module.ecs_cluster.cluster_id
}
