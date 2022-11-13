module "lambda_simple_site" {
  source = "./modules/lambda"

  name       = "simple-site"
  code       = file("${path.module}/../lambdas/simple_site.js")
  prefix     = local.prefix
  http_route = "GET /"

  api_gateway_id            = aws_apigatewayv2_api.api.id
  api_gateway_execution_arn = aws_apigatewayv2_api.api.execution_arn

  environment_vars = {
    "SENSOR_TABLE_NAME" = aws_dynamodb_table.sensor_data.name
  }

  policies = [
  ]
}

resource "aws_iam_policy" "lambda_simple_site_dynamodb" {
  name        = "${local.prefix}-lambda-simple-site-db-access"
  description = "Allows DynamoDB access for a simple site"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:Scan",
        ]
        Effect = "Allow"
        Resource = [
          aws_dynamodb_table.sensor_data.arn,
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_simple_site_dynamodb_attach" {
  role       = module.lambda_simple_site.role_name
  policy_arn = aws_iam_policy.lambda_simple_site_dynamodb.arn
}
