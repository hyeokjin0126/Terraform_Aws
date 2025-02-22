resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "<Service Name>.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "<env>-role"
  }
}

output "iam-role" {
  value = aws_iam_role.role.name
}