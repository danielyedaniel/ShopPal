const AWS = require("aws-sdk");
require("dotenv").config();

// S3 client initialization
const s3 = new AWS.S3({
    accessKeyId: process.env.AWS_S3_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_S3_SECRET_ACCESS_KEY,
})

module.exports = s3;