const express = require("express");
const ddbClient = require("../aws/dynamo");
require("dotenv").config();

const router = express.Router();

router.post("/get", async (req, res) => {
    const params = {
        TableName: process.env.AWS_DyanmoDB_Table,
        KeyConditionExpression: "email = :email AND receiptDate < :profile",
        ExpressionAttributeValues: {
            ":email": req.body.email,
            ":profile": "profile",
        },
    };

    const receipts = await ddbClient.query(params).promise();
    return res.json({items: receipts.Items});
});

module.exports = router;