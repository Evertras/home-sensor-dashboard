module.exports.handler = async (e) => {
  console.log("Event: ", e);
  let responseMessage = "Hello, World!";

  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      message: responseMessage,
    }),
  };
};
