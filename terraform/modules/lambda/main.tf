data "archive_file" "lambda_code" {
  type = "zip"

  source {
    content  = var.code
    filename = "index.js"
  }

  output_path = "${path.module}/.archives/lambda-code-${var.name}.zip"
}
