resource "aws_apigatewayv2_api" "api" {
  name          = local.prefix
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id = aws_apigatewayv2_api.api.id

  name = "${local.prefix}-prod"

  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "dummy" {
  api_id = aws_apigatewayv2_api.api.id

  integration_uri    = module.lambda_dummy.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_integration" "send_data" {
  api_id = aws_apigatewayv2_api.api.id

  integration_uri    = module.lambda_send_data.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "dummy" {
  api_id = aws_apigatewayv2_api.api.id

  route_key = "GET /dummy"
  target    = "integrations/${aws_apigatewayv2_integration.dummy.id}"
}

resource "aws_apigatewayv2_route" "send_data" {
  api_id = aws_apigatewayv2_api.api.id

  route_key = "PUT /sensor/{sensorID}/{measurementKind}"
  target    = "integrations/${aws_apigatewayv2_integration.send_data.id}"
}
