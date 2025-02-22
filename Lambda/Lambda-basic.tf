data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"
        
    principals {
        type = "Service"
        identifiers = ["lambda.amazonaws.com"]
    }
    
    actions = ["sts:AssumeRole"]
    }
}

resource "aws_iam_role" "lambda" {
    name = "<env>-role"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda" {
    filename = "lambda_function_payload.zip"
    function_name = "<env>-function"
    role = aws_iam_role.lambda.arn
    handler = "lambda_function.lambda_handler"
    timeout = "<number>"

    source_code_hash = data.archive_file.lambda.output_base64sha256
    
    runtime = "<runtime>"
}

output "lambda" {
    value = aws_lambda_function.lambda.arn
}