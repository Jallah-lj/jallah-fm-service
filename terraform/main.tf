module "staging" {
  source = "./module/environment"

  bastion_ingress = local.bastion_ingress
  name            = "staging"
}

module "prod" {
  source = "./module/environment"

  bastion_ingress = local.bastion_ingress
  name            = "prod"
}

import {
  to = module.staging.aws_apprunner_service.app
  id = "arn:aws:apprunner:us-east-1:234731604099:service/staging/3c74f1e60a444da897375817031c4a52"
}
