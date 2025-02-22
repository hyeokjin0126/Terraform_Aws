resource "aws_security_group" "SG" {
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

output "SG" {
    value = aws_security_group.SG.id
}

/* 
ALL Treffic 설정 시 Protocol을 -1로 지정합니다.
ex)
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port = "0"
*/