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

  policies = [
  ]
}

resource "aws_iam_policy" "lambda_send_data_dynamodb" {
  name        = "${local.prefix}-lambda-send-data-db-access"
  description = "Allows DynamoDB write access for writing measurements"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
        ]
        Effect = "Allow"
        Resource = [
          aws_dynamodb_table.sensor_data.arn,
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_send_data_dynamodb_attach" {
  role       = module.lambda_send_data.role_name
  policy_arn = aws_iam_policy.lambda_send_data_dynamodb.arn
}

module "lambda_get_measurement" {
  source = "./modules/lambda"

  name   = "get-measurement"
  code   = file("${path.module}/../lambdas/get_measurement.js")
  prefix = local.prefix

  api_gateway_execution_arn = aws_apigatewayv2_api.api.execution_arn

  environment_vars = {
    "SENSOR_TABLE_NAME" = aws_dynamodb_table.sensor_data.name
  }

  policies = [
  ]
}

resource "aws_iam_policy" "lambda_get_measurement_dynamodb" {
  name        = "${local.prefix}-lambda-get-measurement-db-access"
  description = "Allows DynamoDB write access for writing measurements"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
        ]
        Effect = "Allow"
        Resource = [
          aws_dynamodb_table.sensor_data.arn,
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_get_measurement_dynamodb_attach" {
  role       = module.lambda_get_measurement.role_name
  policy_arn = aws_iam_policy.lambda_get_measurement_dynamodb.arn
}
