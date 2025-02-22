resource "aws_iam_user" "user" {
  name = "<User Name>"
}

output "iam-user" {
  value = aws_iam_user.user.name
}