
data "archive_file" "lambda_code_zip" {
    type = "zip"
    source_dir = "./modules/lambda/lambda_code"
    output_path= "./modules/lambda/lambda_code.zip"
}

# Create lambda function and load our code on it
resource "aws_lambda_function" "lambda" {
    function_name = "json_validator"
    role = aws_iam_role.lambda_execution_role.arn
    handler = "lambda.lambda_handler"
    filename = "./modules/lambda/lambda_code.zip"
    source_code_hash = data.archive_file.lambda_code_zip.output_base64sha256
    runtime = "python3.8"

    # vpc_config {
    #     subnet_ids = [var.subnet_id]
    #     security_group_ids = [var.security_group_id]
    # }
}

# Create an appropriate IAM role to execute lambda
resource "aws_iam_role" "lambda_execution_role" {
    name = "lambda_execution_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = ""
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
}
 
# Attach an iam role policy to lambda function
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create Cloudwatch logs to monitor the lambda function
resource "aws_cloudwatch_log_group" "lambda_log_group" {
    name = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
    retention_in_days = 30
}
