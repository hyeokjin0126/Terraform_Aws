resource "aws_flow_log" "flow_log" {
    iam_role_arn = aws_iam_role.role.arn
    log_destination = aws_cloudwatch_log_group.cw_group.arn
    traffic_type = "ALL"
    vpc_id = aws_vpc.vpc.id
}

resource "aws_cloudwatch_log_group" "cw_group" {
    name = "<env>-log"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
    name = "<env>-role"
    assume_role_policy = data.aws_iam_policy.assume_role.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "role" {
  name   = "<env>-role"
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.policy.json
}

output "flow-log" {
    value = aws_flow_log.flow_log.value
}