# Instance role — used by running App Runner tasks to access SSM
resource "aws_iam_role" "app_runner_instance" {
  name = "${var.app_name}-app-runner-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "tasks.apprunner.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "app_runner_ssm" {
  name = "${var.app_name}-ssm-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["ssm:GetParameters"]
        Resource = [
          "arn:aws:ssm:us-west-2:${local.account_id}:parameter/${var.app_name}/*",
          "arn:aws:ssm:us-east-1:${local.account_id}:parameter/POSTGRES_URL",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_runner_ssm" {
  role       = aws_iam_role.app_runner_instance.name
  policy_arn = aws_iam_policy.app_runner_ssm.arn
}

# Access role — used by App Runner to pull images from ECR
resource "aws_iam_role" "app_runner_access" {
  name = "${var.app_name}-apprunner-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "build.apprunner.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "app_runner_ecr" {
  role       = aws_iam_role.app_runner_access.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

import {
  to = aws_iam_role.app_runner_instance
  id = "${var.app_name}-app-runner-role"
}

import {
  to = aws_iam_policy.app_runner_ssm
  id = "arn:aws:iam::${local.account_id}:policy/${var.app_name}-ssm-policy"
}

import {
  to = aws_iam_role.app_runner_access
  id = "${var.app_name}-apprunner-ecr-role"
}
