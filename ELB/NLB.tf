# NLB Load Balancer
resource "aws_lb" "nlb" {
  name = "<env>-nlb"
  internal = false # Internet-facing
#   internal = true # internal
  load_balancer_type = "network"
  security_groups = [aws_security_group.nlb.id]

# Public
  subnet_mapping {
    subnet_id     = aws_subnet.public_a.id
    allocation_id = aws_eip.alb_a.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.public_b.id
    allocation_id = aws_eip.alb_a.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.public_c.id
    allocation_id = aws_eip.alb_a.id
  }

# Private
#   subnet_mapping {
#     subnet_id     = aws_subnet.private_a.id
#     allocation_id = aws_eip.alb_a.id
#   }

#   subnet_mapping {
#     subnet_id     = aws_subnet.private_b.id
#     allocation_id = aws_eip.alb_a.id
#   }

#   subnet_mapping {
#     subnet_id     = aws_subnet.private_c.id
#     allocation_id = aws_eip.alb_a.id
#   }

  tags = {
      Name = "<env>-nlb"
  }
}

# NLB Target Group
resource "aws_lb_target_group" "nlb-tg"{
  name = "<env>-tg"
  port = "80"
  protocol = "HTTP"
  vpc_id  = aws_vpc.main.id
  target_type = "instance"
  
  health_check {
    path = "<Path>"
    protocol = "HTTP"
    healthy_threshold  = 2
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
  }

  tags = {
      Name = "<env>-tg"
  }
}

# NLB Listener
resource "aws_lb_listener" "app-nlb-listner"{
  load_balancer_arn = aws_lb.nlb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.nlb-tg.arn
  }
}

# NLB Attach Server
resource "aws_lb_target_group_attachment" "internal-nlb-attach-resource"{
  target_group_arn = aws_lb_target_group.nlb-tg.arn
  target_id = aws_instance.app.id
  port = 80
  depends_on = [aws_lb_listener.app-nlb-listner]
}

# Security Group
resource "aws_security_group" "nlb" {
  name = "<env>-EC2-SG"
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
    Name = "<env>-nlb-SG"
  }
}

# EIP
resource "aws_eip" "alb_a" {
}

resource "aws_eip" "alb_b" {
}

resource "aws_eip" "alb_c" {
}

output "nlb-SG" {
    value = aws_security_group.nlb.id
}

output "NLB" {
    value = aws_lb.nlb.id
}