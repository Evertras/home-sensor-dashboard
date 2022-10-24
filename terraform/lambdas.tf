module "lambda_dummy" {
  source = "./modules/lambda"

  name   = "dummy"
  code   = file("${path.module}/../lambdas/dummy.js")
  prefix = local.prefix

  api_gateway_execution_arn = aws_apigatewayv2_api.api.execution_arn
}

module "lambda_send_data" {
  source = "./modules/lambda"

  name   = "send-data"
  code   = file("${path.module}/../lambdas/send_data.js")
  prefix = local.prefix

  api_gateway_execution_arn = aws_apigatewayv2_api.api.execution_arn

  environment_vars = {
    "SENSOR_TABLE_NAME" = aws_dynamodb_table.sensor_data.name
  }
}
