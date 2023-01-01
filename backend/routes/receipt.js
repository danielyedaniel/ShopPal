const express = require("express");
const parseReceipt = require("../receiptParser/receiptParser");
const multer = require("multer");
const ddbClient = require("../dynamo");
const RJSON = require('relaxed-json');
require("dotenv").config();

const router = express.Router();
const upload = multer({ dest: 'receiptParser/' });

router.post("/add", upload.single('file'), async (req, res) => {
    const file = req.file;

    const parsedReceipt = RJSON.parse(await parseReceipt(file.filename));

    const receipt = {
        email: req.body.email,
        receiptDate: parsedReceipt.dateOfPurchase,
        store: parsedReceipt.storeName,
        items: parsedReceipt.items,
        total: parsedReceipt.total,
    };

    const params = {
        TableName: "ShopPal",
        Item: receipt,
    }

    return res.json(await ddbClient.put(params).promise());
});

router.post("/delete", async (req, res) => {

});

module.exports = router;