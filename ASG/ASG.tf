resource "aws_autoscaling_group" "asg" {
  name = "web-skills-ap-stable"
  desired_capacity = 2
  min_size = 2
  max_size = 10
  vpc_zone_identifier = [aws_subnet.private_a.id, aws_subnet.private_b.id, aws_subnet.private_c.id]
  target_group_arns = [aws_lb_target_group.alb-tf.arn]

  launch_template {
    id      = aws_launch_template.asg.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "asg" {
  name = "asg-policy"
  autoscaling_group_name = aws_autoscaling_group.asg.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 10.0
  }
}

# AMI
data "aws_ssm_parameter" "latest_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-default-x86_64"
}

resource "aws_launch_template" "asg" {
  name = "web_test_lt"
  image_id = data.aws_ssm_parameter.latest_ami.value
  instance_type = "<Type>"
  key_name = aws_key_pair.keypair.key_name
  iam_instance_profile {
    arn = aws_iam_instance_profile.asg.arn
  }

  vpc_security_group_ids = [aws_security_group.asg.id]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "<env>"
    }
  }

  user_data = base64encode(<<EOF
    #!/bin/bash
    yum update -y
    ...
  EOF
  )
}

resource "aws_security_group" "asg" {
  name = "<env>-ASG-SG"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    from_port = "<Port>"
    to_port = "<Port>"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "<Port>"
    to_port = "<Port>"
  }
 
    tags = {
    Name = "<env>-ASG-SG"
  }
}

resource "aws_iam_role" "asg" {
  name = "<env>-role-bastion"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.asg.name
  policy_arn = "arn:aws:iam::aws:policy/<Policy>"
}

resource "aws_iam_instance_profile" "asg" {
  name = "<env>-profile-asg"
  role = aws_iam_role.asg.name
}