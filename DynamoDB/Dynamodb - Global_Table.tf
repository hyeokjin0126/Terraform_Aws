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

    global_secondary_index {
        name = "GameTitleIndex"
        hash_key = "<hash_key>"
        range_key = "<range_key>"
        write_capacity = 10
        read_capacity = 10
        projection_type = "ALL" # ALl or INCLUDE
    }

    tags = {
        Name = "<dynamodb>"
    }
}

output "dynamodb" {
    value = aws_dynamodb_table.dynamodb.name
}