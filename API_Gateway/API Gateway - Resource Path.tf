## API Gateway
resource "aws_api_gateway_rest_api" "apigw" {
    name = "<env>"
}

# Path
resource "aws_api_gateway_resource" "apigw" {
    parent_id   = aws_api_gateway_rest_api.api.root_resource_id
    rest_api_id = aws_api_gateway_rest_api.api.id
    path_part   = "<Path>"
}

# Method
resource "aws_api_gateway_method" "GET" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_rest_api.apigw.id
  authorization = "NONE"
  http_method = "GET"
}

resource "aws_api_gateway_method" "POST" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_rest_api.apigw.id
  authorization = "NONE"
  http_method = "POST"
}

# API Gateway Intergration
resource "aws_api_gateway_integration" "api_GET" {
  http_method = aws_api_gateway_method.GET.http_method
  resource_id = aws_api_gateway_rest_api.apigw.id
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  integration_http_method = "GET"
  type = "AWS"
  uri = "<arn>"
  credentials = aws_iam_role.apigw.arn
}

resource "aws_api_gateway_integration" "api_POST" {
  http_method = aws_api_gateway_method.POST.http_method
  resource_id = aws_api_gateway_rest_api.apigw.id
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  integration_http_method = "POST"
  type = "AWS"
  uri = "<arn>"
  credentials = aws_iam_role.apigw.arn

  request_templates = {
    "application/json" = <<EOF
{
  "text": "test"
}
EOF
  }
}

# API Gateawy Intergration Response
resource "aws_api_gateway_integration_response" "apigw_intergration_response_GET" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_rest_api.apigw.id
  http_method = aws_api_gateway_method.POST.http_method
  status_code = 200

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_integration.api_GET]
}

resource "aws_api_gateway_integration_response" "apigw_intergration_response_POST" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_rest_api.apigw.id
  http_method = aws_api_gateway_method.POST.http_method
  status_code = 200

  response_templates = {
    "application/json" = ""
  }

  depends_on = [aws_api_gateway_integration.api_POST]
}

# API Gateway Method Response
resource "aws_api_gateway_method_response" "apigw_response_GET" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_rest_api.apigw.id
  http_method = aws_api_gateway_method.GET.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "apigw_response_POST" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  resource_id = aws_api_gateway_rest_api.apigw.id
  http_method = aws_api_gateway_method.POST.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

# Deploy Stage
resource "aws_api_gateway_deployment" "apigw" {
  depends_on = [aws_api_gateway_integration.api_GET, aws_api_gateway_integration.api_POST]
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  stage_name = "<stage>"
}

output "apigw" {
  value = aws_api_gateway_rest_api.apigw.arn
}