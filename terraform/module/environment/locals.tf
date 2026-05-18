locals {
  account_id = data.aws_caller_identity.current.account_id
  ecr_domain = "${local.account_id}.dkr.ecr.${var.ecr_region}.amazonaws.com"
  image_uri  = "${local.ecr_domain}/${var.app_name}:${var.name}"
}
