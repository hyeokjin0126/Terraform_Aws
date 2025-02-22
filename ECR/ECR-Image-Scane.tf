resource "aws_ecr_repository" "ecr" {
  name = "<env>-ecr"

  image_scanning_configuration {
    scan_on_push = true
    }

    tags = {
        Name = "<env>-ecr"
    } 
}