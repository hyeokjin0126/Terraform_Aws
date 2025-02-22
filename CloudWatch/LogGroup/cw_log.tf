resource "aws_cloudwatch_log_group" "cw" {
  name = "<env>"

  tags = {
    Name = "<env>"
  }
}

resource "aws_cloudwatch_log_stream" "cw" {
  name = "<name>"
  log_group_name = aws_cloudwatch_log_group.cw.name
}

output "cw_log_group" {
  value = aws_cloudwatch_log_group.cw.id
} 

output "cw_log_stream" {
  value = aws_cloudwatch_log_stream.cw.id
}