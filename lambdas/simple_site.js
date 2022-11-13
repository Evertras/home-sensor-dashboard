const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async () => {
  const data = await dynamo
    .scan({
      TableName: process.env.SENSOR_TABLE_NAME,
    })
    .promise();

  // Just let errors happen if they happen...
  const allMeasurements = data.value.Items;

  return {
    statusCode: 200,
    body: JSON.stringify({ value: data }),
  };
};
