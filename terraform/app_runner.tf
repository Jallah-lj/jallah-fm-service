resource "aws_apprunner_service" "app" {
  provider     = aws.us_east_1
  service_name = var.environment

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner_access.arn
    }

    image_repository {
      image_identifier      = local.image_uri
      image_repository_type = "ECR"

      image_configuration {
        port = var.app_port

        runtime_environment_secrets = {
          POSTGRES_URL = "arn:aws:ssm:${local.app_runner_region}:${local.account_id}:parameter/POSTGRES_URL"
        }
      }
    }

    auto_deployments_enabled = false
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.app_runner_instance.arn
  }
}
