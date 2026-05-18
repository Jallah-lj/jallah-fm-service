locals {
  bastion_ingress  = []
  account_id       = data.aws_caller_identity.current.account_id
  ecr_region       = "us-west-2"
  app_runner_region = "us-east-1"
  ecr_domain       = "${local.account_id}.dkr.ecr.${local.ecr_region}.amazonaws.com"
  image_uri        = "${local.ecr_domain}/${var.app_name}:${var.environment}"
}
