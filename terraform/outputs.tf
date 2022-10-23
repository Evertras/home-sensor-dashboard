output "api_gateway_prod_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.prod.invoke_url
}

output "lambda_dummy_function_name" {
  value = module.lambda_dummy.function_name
}
