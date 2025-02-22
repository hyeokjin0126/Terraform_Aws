data "aws_iam_policy_document" "assume_role_build" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "build" {
  name = "<env>-build-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_build.json
}

data "aws_iam_policy_document" "build" {
  statement {
    effect = "Allow"

    actions = [
      "logs:*",
      "s3:*",
      "ecr:*",
      "codestar-connections:*",
      "codecommit:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "build" {
  role   = aws_iam_role.build.name
  policy = data.aws_iam_policy_document.build.json
}

resource "aws_codebuild_project" "build" {
  name = "<env>-build"
  service_role = aws_iam_role.build.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/codebuild/skills-build-stress"
      stream_name = "build_log"
    }
  }

  source {
    type = "CODEPIPELINE"
  }
}