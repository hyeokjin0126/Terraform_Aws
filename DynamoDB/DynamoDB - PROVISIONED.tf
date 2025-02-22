resource "aws_dynamodb_table" "dynamodb" {
    name = "<dynamodb>"
    billing_mode   = "PROVISIONED"
    read_capacity  = "<Number>"
    write_capacity = "<Number>"
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

    tags = {
        Name = "<dynamodb>"
    }
}

output "dynamodb" {
    value = aws_dynamodb_table.dynamodb.name
}
