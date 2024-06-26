output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "security_group_ids" {
  value = {
    ecs            = aws_security_group.ecs.id
    vpc_endpoints  = aws_security_group.vpc_endpoints.id
  }
}
