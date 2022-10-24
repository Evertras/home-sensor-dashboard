output "api_gateway_prod_url" {
  description = "Base URL for API Gateway stage."

  value = aws_apigatewayv2_stage.prod.invoke_url
}

output "lambda_dummy_function_name" {
  value = module.lambda_dummy.function_name
}

resource "local_sensitive_file" "test_envrc" {
  filename = terraform.workspace == "dev" ? "${path.module}/../tests/.envrc" : "${path.module}/../tests/.envrc-${terraform.workspace}"

  content = <<EOF
source_env_if_exists ../.envrc
export AWS_ACCESS_KEY_ID=${aws_iam_access_key.test_user.id}
export AWS_SECRET_ACCESS_KEY=${aws_iam_access_key.test_user.secret}
export TEST_DYNAMODB_TABLE=${aws_dynamodb_table.sensor_data.name}
EOF
}
