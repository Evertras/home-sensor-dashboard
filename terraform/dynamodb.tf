resource "aws_dynamodb_table" "temp_table" {
  name     = "HomeSensorDashboardSensorData"
  hash_key = "SensorID"

  billing_mode = "PAY_PER_REQUEST"

  /* Only define the key attribute here */
  attribute {
    name = "SensorID"
    type = "S"
  }
}
