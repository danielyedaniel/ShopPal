const express = require("express");
const parseReceipt = require("../receiptParser/receiptParser");
const ddbClient = require("../aws/dynamo");
const s3 = require("../aws/s3");
const fs = require("fs");
const RJSON = require('relaxed-json');
require("dotenv").config();

const router = express.Router();

router.post("/add", async (req, res) => {
    const file = req.file;

    if (!file) return res.status(400).json("No file uploaded");

    // Upload file to S3
    const s3params = {
        Bucket: process.env.AWS_S3_BUCKET_NAME,
        Key: file.filename,
        Body: fs.readFileSync(file.path),
    };

    const uploadedImage = await s3.upload(s3params).promise();

    const parsedReceipt = RJSON.parse(await parseReceipt(file.filename));

    const receipt = {
        email: req.body.email,
        receiptDate: (new Date()).toISOString(),
        store: parsedReceipt.storeName,
        items: parsedReceipt.items,
        total: parsedReceipt.total,
        image: uploadedImage.Location,
    };

    const params = {
        TableName: process.env.AWS_DyanmoDB_Table,
        Item: receipt,
    };

    await ddbClient.put(params).promise();

    fs.unlinkSync('./receiptParser/' + file.filename);
    return res.json(receipt)
});

router.post("/test/add", async (req, res) => {
    const file = req.file;

    if (!file) return res.status(400).json("No file uploaded");

    fs.unlinkSync('./receiptParser/' + file.filename);
    return res.json("Success")
});

router.post("/delete", async (req, res) => {

});

module.exports = router;