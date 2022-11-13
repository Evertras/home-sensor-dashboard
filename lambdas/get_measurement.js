const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (e) => {
  const sensorID = e.pathParameters.sensorID;
  const measurementKind = e.pathParameters.measurementKind.toLowerCase();

  const allowedMeasurementKinds = ["temperaturec", "humidity100"];

  if (!allowedMeasurementKinds.some((s) => s === measurementKind)) {
    console.log("Bad measurement kind:", measurementKind);
    return {
      statusCode: 400,
      body: "Unknown measurement kind",
    };
  }

  const data = await dynamo
    .get({
      TableName: process.env.SENSOR_TABLE_NAME,
      Key: {
        SensorID: sensorID,
        MeasurementType: measurementKind,
      },
    })
    .promise();

  // Assume this is not found for now
  if (!data || !data.Item || data.Item.MeasurementValue === undefined) {
    return {
      statusCode: 404,
    };
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ value: data.Item.MeasurementValue }),
  };
};
