# modules/ecs_cluster/outputs.tf

output "cluster_id" {
  value = aws_ecs_cluster.this.id
}
