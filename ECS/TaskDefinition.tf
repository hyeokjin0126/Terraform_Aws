resource "aws_ecs_task_definition" "ecs" {
  family = "<env>-td"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = "1024"
  memory = "2048"

  container_definitions = jsonencode([
    {
      name = "<env>-cnt"
      image = "<Image>"
      essential = true
      portMappings = [{
        containerPort = "<Port>"
      }]
    }
  ])
}