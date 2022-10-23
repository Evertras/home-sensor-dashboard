module "lambda_dummy" {
  source = "./modules/lambda"

  name = "dummy"
  code = file("${path.module}/../lambdas/dummy.js")

  api_gateway_execution_arn = aws_apigatewayv2_api.api.execution_arn
}
