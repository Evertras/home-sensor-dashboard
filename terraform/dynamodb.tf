resource "aws_dynamodb_table" "sensor_data" {
  name      = terraform.workspace == "default" ? "HomeSensorDashboardSensorData" : "HomeSensorDashboardSensorDataDev"
  hash_key  = "SensorID"
  range_key = "MeasurementType"

  billing_mode = "PAY_PER_REQUEST"

  /* Only define the key attributes here */
  attribute {
    name = "SensorID"
    type = "S"
  }

  attribute {
    name = "MeasurementType"
    type = "S"
  }
}
