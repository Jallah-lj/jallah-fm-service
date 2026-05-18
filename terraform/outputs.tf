output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "staging_service_url" {
  value = module.staging.service_url
}

output "staging_service_arn" {
  value = module.staging.service_arn
}

output "prod_service_url" {
  value = module.prod.service_url
}

output "prod_service_arn" {
  value = module.prod.service_arn
}
