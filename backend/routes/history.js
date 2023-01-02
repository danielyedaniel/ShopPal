const express = require("express");
const ddbClient = require("../aws/dynamo");

const router = express.Router();

router.post("/get", async (req, res) => {
    const params = {
        TableName: "ShopPal",
        KeyConditionExpression: "email = :email AND receiptDate < :profile",
        ExpressionAttributeValues: {
            ":email": req.body.email,
            ":profile": "profile",
        },
    };

    const receipts = await ddbClient.query(params).promise();
    return res.json(receipts.Items);
});

module.exports = router;