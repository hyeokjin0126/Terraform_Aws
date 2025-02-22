resource "aws_iam_user" "user" {
  name = "<User Name>"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "<env>-attachment"
  users      = [aws_iam_user.user.name]
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect    = "Allow"
    actions   = ["<Service Name>:Describe*"]
    resources = ["*"]
  }
}

output "iam-user" {
  value = aws_iam_user.user.name
}