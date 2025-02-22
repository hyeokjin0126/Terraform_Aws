resource "aws_kinesis_stream" "kds" {
  name = "<env>-kds"
  shard_count = "<Number>"
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED" # PROVISIONED or ON_DEMAND
  }

  tags = {
    Environment = "<env>-kds"
  }
}

output "kds" {
    value = aws_kinesis_stream.kds.id
}