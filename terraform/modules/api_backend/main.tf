resource "aws_api_gateway_rest_api" "api"{
    name = "api-http"
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "submissions"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "api_integration"{
    name = "api-integration"
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.api_resource.id
    http_method = aws_api_gateway_method.api_method.http_method
    integration_type = "AWS_PROXY"
    integration_http_method = "POST"
    uri = aws_lambda_function.lambda.invoke_arn
}

resource "aws_api_gateway_api_key" "api-key" {
    name = "api-key"
}

data "archive_file" "lambda_code_zip" {
    type = "zip"
    source_dir = "./modules/api_backend/lambda.py"
    output_path= "./modules/api_backend/lambda_code.zip"
}

resource "aws_lambda_function" "lambda" {
    function_name = "json_validator"
    role = ---------iam-role-----------
    handler = "lambda.lambda_handler"
    filename = "lambda_code.zip"
    source_code_hash = data.archive_file.lambda_code_zip.output_base64sha256
    runtime = "python3.8"
}

resource "aws_lambda_permission" "api-perimission" {
    statement_id = "AllowExecutionFromAPIGateway"
    action "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda.arn
    principal = "apigateway.amazonaws.com"
    source_arn = aws_apigatewayv2_api.api.function_name
}

// add vpc link so that api can communicate with S3 bucket

resource "aws_s3_bucket" "s3_bucket_storage" {
    bucket = "s3_bucket_storage"
}

resource "aws_s3_bucket_acl" "example" {
    bucket = aws_s3_bucket.s3_bucket_storage.id
    acl    = "private"
}