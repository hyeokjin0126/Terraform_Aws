resource "aws_ecr_repository" "ecr" {
  name = "<env>-ecr"
  image_tag_mutability = "MUTABLE" # MUTABLE or IMMUTABLE

    tags = {
        Name = "<env>-ecr"
    } 
}