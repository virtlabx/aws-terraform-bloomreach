variable "name" {
  description = "name of the repository"
  type        = string
}

variable "tags" {
  description = "Tags for ecr repository"
  type        = map
}

resource "aws_ecr_repository" "ecr-repo" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"
  tags                 = var.tags
  image_scanning_configuration {
    scan_on_push = true
  }
}