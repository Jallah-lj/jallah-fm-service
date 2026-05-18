data "aws_caller_identity" "current" {}

data "aws_iam_role" "instance" {
  name = "${var.app_name}-app-runner-role"
}

data "aws_iam_role" "access" {
  name = "${var.app_name}-apprunner-ecr-role"
}
