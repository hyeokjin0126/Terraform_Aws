resource "aws_ecs_service" "ecs" {
  name            = "<env>-svc"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.ecs.arn
  desired_count   = 2

    network_configuration {
      subnets = [ var.private["a"], var.private["c"] ]
      security_groups = [ aws_security_group.ecs-svc.id ]
      assign_public_ip = false
    }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb-tg.arn
    container_name = "<env>-cnt"
    container_port = 80
  }
}

resource "aws_security_group" "ECS" {
  name = "<env>-ECS-SG"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "80"
    to_port = "80"
  }

  egress {
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port = "0"
  }
 
    tags = {
    Name = "<env>-ECS-SG"
  }
}