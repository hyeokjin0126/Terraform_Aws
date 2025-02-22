data "aws_iam_policy_document" "assume_role_deploy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "deploy" {
  name = "<env>-deloy-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_deploy.json
}

data "aws_iam_policy_document" "deploy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:*",
      "s3:*",
      "ecr:*",
      "ecs:*",
      "elasticloadbalancing:*",
      "ec2:*",
      "lambda:*",
      "iam:PassRole",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "deploy" {
  role   = aws_iam_role.deploy.name
  policy = data.aws_iam_policy_document.deploy.json
}

resource "aws_codedeploy_app" "ecs" {
  compute_platform = "ECS"
  name = "<env>-app"
}

resource "aws_codedeploy_deployment_group" "deploy_group" {
  app_name = aws_codedeploy_app.ecs.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name = "<env>-deploy_group"
  service_role_arn = aws_iam_role.deploy.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 0
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.cluster.name
    service_name = aws_ecs_service.svc.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.listener.arn]
      }

      target_group {
        name = aws_lb_target_group.tg1.name
      }

      target_group {
        name = aws_lb_target_group.tg2.name
      }
    }
  }
}