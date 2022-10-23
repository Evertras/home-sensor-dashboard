resource "aws_dynamodb_table" "temp_table" {
  name     = "TempDeleteMe"
  hash_key = "ID"

  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "ID"
    type = "S"
  }
}
