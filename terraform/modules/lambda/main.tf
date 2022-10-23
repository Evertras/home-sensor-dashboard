data "archive_file" "lambda_code" {
  type = "zip"

  source {
    content  = var.code
    filename = "index.js"
  }

  output_path = "${path.module}/.archives/lambda-code-${var.name}.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = local.prefix

  filename = data.archive_file.lambda_code.output_path

  source_code_hash = filebase64sha256(data.archive_file.lambda_code.output_path)

  runtime = "nodejs12.x"
  handler = "index.handler"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "${local.prefix}-exec"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
