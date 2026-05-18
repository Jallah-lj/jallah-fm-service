locals {
  bastion_ingress = []
  account_id      = data.aws_caller_identity.current.account_id
  ecr_region      = "us-west-2"
  ecr_domain      = "${local.account_id}.dkr.ecr.${local.ecr_region}.amazonaws.com"
}
