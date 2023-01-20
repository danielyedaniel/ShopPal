const express = require("express");
const parseReceipt = require("../receiptParser/receiptParser");
const ddbClient = require("../aws/dynamo");
const s3 = require("../aws/s3");
const fs = require("fs");
const RJSON = require('relaxed-json');
require("dotenv").config();

const router = express.Router();

// Add a receipt to the database
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

    // Parse receipt using receipt parser function
    let parsedReceipt;
    try {
        parsedReceipt = RJSON.parse(await parseReceipt(file.filename));
    } catch(err) {
        fs.unlinkSync('./receiptParser/' + file.filename);
        return res.status(400).json(err);
    }

    const receipt = {
        email: req.body.email,
        receiptDate: (new Date()).toISOString(),
        store: parsedReceipt.storeName,
        items: parsedReceipt.items,
        address: parsedReceipt.address,
        total: parsedReceipt.total,
        image: uploadedImage.Location,
    };

    // Check if any fields are undefined
    if (receipt.total === undefined) receipt.total = 0;
    if (receipt.store === undefined) receipt.store = 'unknown';
    if (receipt.address === undefined) receipt.address = 'unknown';
    if (receipt.items === undefined) receipt.items = [];

    const params = {
        TableName: process.env.AWS_DyanmoDB_Table,
        Item: receipt,
    };

    // Add receipt to database
    await ddbClient.put(params).promise();

    // Delete image that was locally saved
    fs.unlinkSync('./receiptParser/' + file.filename);

    return res.json(receipt)
});

// Test api 
router.post("/test/add", async (req, res) => {
    const file = req.file;

    if (!file) return res.status(400).json("No file uploaded");

    fs.unlinkSync('./receiptParser/' + file.filename);
    return res.json("Success")
});

// Test api
router.post("/test/add2", async (req, res) => {
    const file = req.file;

    if (!file) return res.status(400).json("No file uploaded");

    // Upload file to S3
    const s3params = {
        Bucket: process.env.AWS_S3_BUCKET_NAME,
        Key: file.filename,
        Body: fs.readFileSync(file.path),
    };

    const uploadedImage = await s3.upload(s3params).promise();

    // const parsedReceipt = RJSON.parse(await parseReceipt(file.filename));

    const receipt = {
        email: req.body.email,
        receiptDate: (new Date()).toISOString(),
        store: 'test',
        items: 'test',
        total: 'test',
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

router.post("/delete", async (req, res) => {

});

module.exports = router;