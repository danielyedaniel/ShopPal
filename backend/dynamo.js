const AWS = require("aws-sdk");
require("dotenv").config();

AWS.config.update({
    region: process.env.AWS_DEFAULT_REGION,
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
});

const ddbClient = new AWS.DynamoDB.DocumentClient();

// const getUsers = async () => {
//     const params = {
//         TableName: "ShopPal",
//     };

//     return await ddbClient.scan(params).promise();
// };

module.exports = ddbClient;