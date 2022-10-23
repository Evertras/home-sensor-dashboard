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

There should be no global dependencies except Make and Python 3+, which are
generally pre-installed on any machine this should be running on. Docker is
required for local testing with [Localstack](https://github.com/localstack/localstack).

## Deploying locally

The rest of my infrastructure uses Terraform, so SAM is skipped in favor of
doing some manual bits in Terraform.

[Localstack](https://github.com/localstack/localstack) is used for local
testing. [Terraform can be run against
Localstack](https://docs.localstack.cloud/integrations/terraform/), and this is
baked into the [Makefile](./Makefile) by running `make local-tf-apply`.

The `awslocal` utility is also installed via Makefile.

Check [.envrc.example](./.envrc.example) to see how to configure all this for
easier use. Some quick reference examples are given below.

```bash
# Check DynamoDB tables
awslocal dynamodb list-tables

# Invoke a lambda (replace 'idk')
awslocal lambda invoke --function-name=evertras-home-dashboard-idk response.json
```

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

- [Localstack + Terraform](https://docs.localstack.cloud/integrations/terraform/)
- [Lambda + API Gateway with Terraform](https://learn.hashicorp.com/tutorials/terraform/lambda-api-gateway)
