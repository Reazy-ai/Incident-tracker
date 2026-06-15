resource "aws_ecr_repository" "incident_api" {
  name                 = "incident-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}