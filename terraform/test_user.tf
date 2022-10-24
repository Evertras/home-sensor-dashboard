resource "aws_iam_user" "test_user" {
  name = "${local.prefix}-test-user"
}

resource "aws_iam_access_key" "test_user" {
  user = aws_iam_user.test_user.name
}

resource "aws_iam_user_policy" "test_user" {
  user = aws_iam_user.test_user.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:DeleteItem",
        ]
        Effect = "Allow"
        Resource = [
          aws_dynamodb_table.sensor_data.arn
        ]
      },
    ]
  })
}
/*
{
            "Action": [
                "dynamodb:List*",
                "dynamodb:DescribeReservedCapacity*",
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeTimeToLive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "dynamodb:BatchGet*",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTable",
                "dynamodb:Get*",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchWrite*",
                "dynamodb:CreateTable",
                "dynamodb:Delete*",
                "dynamodb:Update*",
                "dynamodb:PutItem"
            ],
            "Resource": [
                "arn:aws:dynamodb:::table/"
            ],
            "Effect": "Allow"
        }
        */
