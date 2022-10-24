resource "aws_dynamodb_table" "sensor_data" {
  name     = terraform.workspace == "default" ? "HomeSensorDashboardSensorData" : "HomeSensorDashboardSensorDataDev"
  hash_key = "SensorID"

  billing_mode = "PAY_PER_REQUEST"

  /* Only define the key attribute here */
  attribute {
    name = "SensorID"
    type = "S"
  }
}
