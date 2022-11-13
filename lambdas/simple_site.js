const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

module.exports.handler = async () => {
  const data = await dynamo
    .scan({
      TableName: process.env.SENSOR_TABLE_NAME,
    })
    .promise();

  // Just let errors happen if they happen...
  const allMeasurements = data.Items;

  const measurementBySensor = {};

  for (let data of allMeasurements) {
    if (!measurementBySensor[data.SensorID]) {
      measurementBySensor[data.SensorID] = {};
    }

    measurementBySensor[data.SensorID][data.MeasurementType] =
      data.MeasurementValue;
  }

  const rows = Object.keys(measurementBySensor).map((id) => {
    const data = measurementBySensor[id];
    const tempC = data.temperaturec;
    const tempF = Math.floor(tempC * 1.8 + 32);

    return `<tr><td>${id}</td><td>${tempC}</td><td>${tempF}</td><td>${
      data.humidity100 || "N/A"
    }%</td></tr>`;
  });

  const table = `
<table>
  <tr>
    <th>Location</th>
    <th>Temperature (C)</th>
    <th>Temperature (F)</th>
    <th>Humidity (100%)</th>
  </tr>
  ${rows.join("\n")}
</table>
`;

  const page = `
<html>
  <body>
    ${table}
  </body>
</html>
  `;

  return {
    statusCode: 200,
    body: page,
    headers: {
      "Content-type": "text/html",
    },
  };
};
