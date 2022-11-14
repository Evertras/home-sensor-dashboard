resource "aws_apigatewayv2_api" "api" {
  name          = local.prefix
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id = aws_apigatewayv2_api.api.id

  name = local.prefix

  auto_deploy = true

  default_route_settings {
    throttling_rate_limit  = 1
    throttling_burst_limit = 1
  }
}
