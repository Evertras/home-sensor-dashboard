# Home sensor dashboard

A dashboard for home sensor data. This is more of a playground for doing AWS
serverless development than a real useful project.

All tools/dependencies are installed locally as much as possible. Check
[.envrc.example](./.envrc.example) for a sample of how to add the local tooling
to the local path for easier use.

## Goals

This is intended as a sandbox/reference for building a site using AWS Lambdas,
API Gateway, and being able to test everything locally with localstack,
including the Terraform deployment.

## Design

The initial design is very simple. Data is stored in a DynamoDB table to keep
the latest sensor data. The database itself is inaccessible to any other
service. Instead, outside services must use a provided lambda function via API
Gateway to set sensor data.

In the future some kind of event streaming is a much better solution, but for
the moment there is no event stream for this data as this is all physically
local to some personal equipment.

### Data schema

There is a single table for sensor data in DynamoDB which contains a record for
each sensor reading. For the moment, no history is kept. In the future, some
limited history may be kept, but a closer look should be taken to understand
how to deal with heavy time series data properly.

The schema uses the following format for latest measurements:

| Attribute        | Type | Details                                                                                                                                                                    |
| ---------------- | ---- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| SensorID         | S    | **Partition Key.** The unique ID of the sensor.                                                                                                                            |
| MeasurementType  | S    | **Secondary Key.** The measurement type of the sensor, such as TemperatureC or Humidity100. Unit is always included in the name, such as C for Celsius and 100 for 0-100%. |
| MeasurementValue | N    | The actual value of the measurement that was taken.                                                                                                                        |
| Location         | S    | The physical location of the sensor.                                                                                                                                       |
| Timestamp        | D    | The timestamp that this measurement was taken.                                                                                                                             |

## References

- [https://docs.localstack.cloud/integrations/terraform/](Localstack +
  Terraform)
