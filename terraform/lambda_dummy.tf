module "lambda_dummy" {
  source = "./modules/lambda"

  name       = "dummy"
  code       = file("${path.module}/../lambdas/dummy.js")
  prefix     = local.prefix
  http_route = "GET /dummy"

  api_gateway_id            = aws_apigatewayv2_api.api.id
  api_gateway_execution_arn = aws_apigatewayv2_api.api.execution_arn
}
