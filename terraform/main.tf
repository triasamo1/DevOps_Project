# resource  "aws_vpc" "sandbox-vpc" {
#     cidr_block = var.vpc_cidr_block
# }

# module "network" {
#     source = "./modules/network"
#     my_ip = var.my_ip
# }

module "lambda_function"{
    source = "./modules/lambda"
    # security_group_id = module.network.security_group_id
    # subnet_id = module.network.subnet_id
}

module "api_backend"{
    source = "./modules/api_backend"
    account_id = var.account_id
    lambda_function_arn = module.lambda_function.lambda_function_arn
    lambda_function_invoke_arn = module.lambda_function.lambda_function_invoke_arn
    # vpc_endpoint_id = module.network.vpc_endpoint_id

    depends_on = [
        module.lambda_function
    ]
}

module "s3_bucket"{
    source = "./modules/s3_bucket"
}