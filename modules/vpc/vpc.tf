resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-private"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "ecs" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-ecs-sg"
  }
}

resource "aws_security_group" "vpc_endpoints" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-vpc-endpoints-sg"
  }
}

resource "aws_security_group_rule" "allow_all_outbound_ecs" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}

resource "aws_security_group_rule" "allow_all_inbound_vpc_endpoints" {
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "-1"
  source_security_group_id  = aws_security_group.ecs.id
  security_group_id         = aws_security_group.vpc_endpoints.id
}

# VPC Endpoint for ECR Docker
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  tags = {
    Name = "${var.vpc_name}-ecr-dkr-endpoint"
  }
}

# VPC Endpoint for ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  tags = {
    Name = "${var.vpc_name}-ecr-api-endpoint"
  }
}

# VPC Endpoint for ECS
resource "aws_vpc_endpoint" "ecs" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ecs"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  tags = {
    Name = "${var.vpc_name}-ecs-endpoint"
  }
}

# VPC Endpoint for ECS Agent
resource "aws_vpc_endpoint" "ecs_agent" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ecs-agent"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  tags = {
    Name = "${var.vpc_name}-ecs-agent-endpoint"
  }
}
