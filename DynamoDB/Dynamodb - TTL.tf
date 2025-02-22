resource "aws_dynamodb_table" "dynamodb" {
    name = "<dynamodb>"
    billing_mode   = "PAY_PER_REQUEST" # PAY_PER_REQUEST or PROVISIONED
    hash_key = "<hash_key>"
    # range_key = "<range_key>"
    
    # attribute {
    #     name = "<Name>"
    #     type = "S"
    # }

    # attribute {
    #     name = "<Name>"
    #     type = "N"
    # }

    ttl {
        attribute_name = "<dynamodb>"
        enabled = false
      }

    tags = {
        Name = "<dynamodb>"
    }
}

output "dynamodb" {
    value = aws_dynamodb_table.dynamodb.name
}