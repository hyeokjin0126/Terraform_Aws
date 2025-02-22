## EC2
resource "aws_instacne" "bastion" {
  ami = data.aws_ssm_parameter.latest_ami.value
  subnet_id = aws_subnet.public_a.id
  instance_type = "<Type>"
  key_name = "<env>"
  vpc_security_group_ids = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  private_ip = "<CIDR>"
  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  ...
  EOF
  tags = {
    Name = "<env>-bastion-ec2"
  }
}

## Keypair
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "keypair" {
  key_name = "<env>"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "keypair" {
  content = tls_private_key.rsa.private_key_pem
  filename = "../<env>.pem"
}

output "keypair" {
    value = local_file.keypair.id
}

## Public Security Group
resource "aws_security_group" "bastion" {
  name = "<env>-EC2-SG"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "<Port>"
    to_port = "<Port>"
  }

  egress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "<Port>"
    to_port = "<Port>"
  }
 
    tags = {
    Name = "<env>-EC2-SG"
  }
}

## IAM
resource "aws_iam_role" "bastion" {
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

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_instance_profile" "bastion" {
  name = "<env>-profile-bastion"
  role = aws_iam_role.bastion.name
}

output "bastion" {
  value = aws_instacne.bastion.id
}

output "bastion-sg" {
  value = aws_security_group.bastion.id
}