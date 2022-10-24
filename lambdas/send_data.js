const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async (e) => {
  const sensorID = e.pathParameters.sensorID;
  const measurementKind = e.pathParameters.measurementKind.toLowerCase();
  const requestBody = JSON.parse(e.body);

  const allowedMeasurementKinds = ["temperaturec", "humidity100"];

  if (!allowedMeasurementKinds.some((s) => s === measurementKind)) {
    console.log("Bad measurement kind:", measurementKind);
    return {
      statusCode: 400,
      body: "Unknown mesaurement kind",
    };
  }

  if (!requestBody || !requestBody.value || isNaN(requestBody.value)) {
    console.log("Bad measurement value:", requestBody);
    return {
      statusCode: 400,
      body: "Could not parse measurement value",
    };
  }

  await dynamo
    .put({
      TableName: process.env.SENSOR_TABLE_NAME,
      Item: {
        SensorID: sensorID,
        MeasurementType: measurementKind,
        MeasurementValue: requestBody.value,
      },
    })
    .promise();

  return {
    statusCode: 200,
  };
};
