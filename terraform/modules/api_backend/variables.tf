variable "account_id" {
    type = string
    description = "aws account ID"
}

variable "lambda_function_arn" {
    type = string
    description = "Lambda function ARN (Resource Name)"
}

variable "lambda_function_invoke_arn" {
    type = string
    description = "Lambda function invoke ARN "
}

# variable "vpc_endpoint_id" {
#     type = string
#     description = "VPC Endpoint ID"
# }
