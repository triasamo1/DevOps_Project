# resource  "aws_vpc" "sandbox-vpc" {
#     cidr_block = var.vpc_cidr_block
# }

module "lambda_function"{
    source = "./modules/lambda"
}

module "api_backend"{
    source = "./modules/api_backend"
    account_id = var.account_id
    lambda_function_arn = module.lambda_function.lambda_function_arn
    lambda_function_invoke_arn = module.lambda_function.lambda_function_invoke_arn

    depends_on = [
        module.lambda_function
    ]
}

# module "s3_bucket"{
#     source = "./modules/s3_bucket"
# }