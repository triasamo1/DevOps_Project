resource  "aws_vpc" "sandbox-vpc" {
    cidr_block = var.vpc_cidr_block
}

# iam role