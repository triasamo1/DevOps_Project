# Create API Gateway
resource "aws_api_gateway_rest_api" "api"{
    name = "api-http"
}

# Create API Gateway resource (part of the api path). For example here, https://api.example.com/submissions/.....
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "submissions"
}

# Define a POST method for the "submissions" API resource with API Key Validation.
resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "POST"
  authorization = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_usage_plan" "api_usage_plan" {
    name = "my_usage_plan"

    api_stages {
        api_id = aws_api_gateway_rest_api.api.id
        stage  = aws_api_gateway_stage.api_stage.stage_name
    }
    quota_settings {
        limit  = 1
        period = "DAY"
    }
}

# Auto-generate an API Key
resource "aws_api_gateway_api_key" "api-key" {
    name = "api-key"
}

# Associate usage plan with api key
resource "aws_api_gateway_usage_plan_key" "api_usage_plan_key" {
    key_id        = aws_api_gateway_api_key.api-key.id
    key_type      = "API_KEY"
    usage_plan_id = aws_api_gateway_usage_plan.api_usage_plan.id
}

# Create an integration type so that we return the right response.
resource "aws_api_gateway_integration" "api_integration"{
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.api_resource.id
    http_method = aws_api_gateway_method.api_method.http_method
    type = "AWS_PROXY"  
    integration_http_method = "POST"
    uri = var.lambda_function_invoke_arn
}

# Create a method response with status code 200
resource "aws_api_gateway_method_response" "api_method_response" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.api_resource.id
    http_method = aws_api_gateway_method.api_method.http_method
    status_code = "200"
}

# stage and deploy our api
resource "aws_api_gateway_deployment" "api_deployment" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    triggers = {
        redeployment = sha1(jsonencode([
            aws_api_gateway_resource.api_resource.id,
            aws_api_gateway_method.api_method.id,
            aws_api_gateway_integration.api_integration.id
        ]))
    }
}
resource "aws_api_gateway_stage" "api_stage" {
    deployment_id = aws_api_gateway_deployment.api_deployment.id
    rest_api_id = aws_api_gateway_rest_api.api.id
    stage_name = "net2grid-dev"
}

# Allow API Gateway to invoke the lambda function
resource "aws_lambda_permission" "api_permission" {
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = var.lambda_function_arn
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:eu-central-1:${var.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.api_method.http_method}${aws_api_gateway_resource.api_resource.path}"
}

