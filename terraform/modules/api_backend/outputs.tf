output "api_url" {
    value = "${aws_api_gateway_deployment.api_deployment.invoke_url}${aws_api_gateway_stage.api_stage.stage_name}${aws_api_gateway_resource.api_resource.path}"
}

output "api_key" {
    value = aws_api_gateway_api_key.api-key.value
    sensitive = true
}