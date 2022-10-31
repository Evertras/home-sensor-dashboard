resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  count  = var.http_route == "" ? 0 : 1
  api_id = var.api_gateway_id

  integration_uri    = aws_lambda_function.lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "http_route" {
  count  = var.http_route == "" ? 0 : 1
  api_id = var.api_gateway_id

  route_key = var.http_route
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration[0].id}"
}
