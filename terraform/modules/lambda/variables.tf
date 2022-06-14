# variable "security_group_id" {
#     type = string
#     description = "Security Group ID"
# }

# variable "subnet_id" {
#     type = string
#     description = "Subnet ID"
# }

variable "iam_policy_arn" {
    description = "IAM Policy to be attached to role"
    type = list(string)
}