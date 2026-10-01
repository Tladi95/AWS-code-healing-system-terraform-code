output "ecr_repository_url" {
  description = "ECR repository URL for pushing Docker images"
  value       = aws_ecr_repository.code-healing-repo.repository_url
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.code-healing-service.name
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.code-healing-cluster.name
}

output "github_actions_role_arn" {
  description = "IAM role ARN to set as AWS_ROLE_ARN in GitHub Actions variables"
  value       = aws_iam_role.github_actions_ecr.arn
}
