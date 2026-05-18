variable "name" {
  description = "Environment name (e.g. staging, prod)"
}

variable "bastion_ingress" {
  description = "List of ingress CIDR rules for the bastion"
  default     = []
}

variable "app_name" {
  default = "fem-fd-service"
}

variable "ecr_region" {
  default = "us-west-2"
}

variable "app_port" {
  default = "8080"
}
