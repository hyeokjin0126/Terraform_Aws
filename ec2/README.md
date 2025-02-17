## IAM Admin Role
```
resource "aws_iam_role" "ec2-iam" {
  name = "Ec2-Admin-Role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  }
  EOF
}
resource "aws_iam_role_policy_attachment" "ec2-iam-attach" { # AdminAccess 정책 연결
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role = aws_iam_role.ec2-iam.name
}
```


# --- Security Group ---

resource "aws_security_group" "ec2-security-group" {
  vpc_id = aws_vpc.vpc.id
  name   = "skills-bastion-sg"

  # 인바운드
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2220
    to_port     = 2220
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 아웃바운드
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "skills-sg" }
}


# --- EC2 ---

resource "aws_iam_instance_profile" "example-profile" {
  name = "Ec2-Admin-Role" # Ec2에 넣을 IAM 역활 이름
  role = aws_iam_role.ec2-iam.name
}

resource "aws_instance" "ec2" {
  depends_on = [aws_iam_role.ec2-iam]  # IAM 역할 정책 연결이 완료될 때까지 대기

  ami           = "ami-00ba43a774eb5870b"
  associate_public_ip_address = true
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public-sub-a.id
  vpc_security_group_ids = [aws_security_group.ec2-security-group.id]

  # 사용자 데이터
  user_data = <<-EOF
    #!/bin/bash
    echo 'Port 2220' >> /etc/ssh/sshd_config
    systemctl restart sshd
    sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
    echo "ec2-user:Skills2024**" | chpasswd
    systemctl restart sshd
  EOF

  iam_instance_profile = aws_iam_instance_profile.example-profile.name
  tags = { Name = "skills-bastion" }
}

output "ec2_public_ip" {
  value = "Ec2의 퍼블릭 IP = ${aws_instance.ec2.public_ip}"
}