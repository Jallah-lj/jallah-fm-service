resource "aws_apprunner_service" "app" {
  service_name = var.name

  source_configuration {
    authentication_configuration {
      access_role_arn = data.aws_iam_role.access.arn
    }

    image_repository {
      image_identifier      = local.image_uri
      image_repository_type = "ECR"

      image_configuration {
        port = var.app_port

        runtime_environment_secrets = {
          POSTGRES_URL = "arn:aws:ssm:us-east-1:${local.account_id}:parameter/POSTGRES_URL"
        }
      }
    }

    auto_deployments_enabled = false
  }

  instance_configuration {
    instance_role_arn = data.aws_iam_role.instance.arn
  }
}
