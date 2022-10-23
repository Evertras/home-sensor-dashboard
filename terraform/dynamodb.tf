resource "aws_dynamodb_table" "sensor_data" {
  name     = "HomeSensorDashboardSensorData"
  hash_key = "SensorID"

  billing_mode = "PAY_PER_REQUEST"

  /* Only define the key attribute here */
  attribute {
    name = "SensorID"
    type = "S"
  }
}
