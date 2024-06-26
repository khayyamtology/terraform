terraform {
  backend "s3" {
    bucket         = "kk-ecs-fargate-terraform-remote-state"
    key            = "terraform/state"
    region         = "us-east-1"  # Hardcoded region
    dynamodb_table = "kk-terraform-lock-table"
    encrypt        = true
  }
}
