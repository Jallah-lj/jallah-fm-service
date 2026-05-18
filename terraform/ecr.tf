resource "aws_ecr_repository" "app" {
  provider             = aws.us_west_2
  name                 = var.app_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

import {
  to = aws_ecr_repository.app
  id = var.app_name
}
