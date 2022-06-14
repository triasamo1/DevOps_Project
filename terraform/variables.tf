variable "account_id" {
    type = string
    description = "aws account ID"
}

variable "iam_policy_arn" {
    description = "IAM Policy to be attached to role"
    type = list(string)
}