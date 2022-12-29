const express = require("express");
const bcrypt = require("bcrypt");
const ddbClient = require("../dynamo");
const Joi = require("joi");

const router = express.Router();

router.post("/signup", async (req, res) => {
    const user = {
        email: req.body.email,
        receiptDate: "profile",
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        password: req.body.password,
    }

    const schema = Joi.object({
        email: Joi.string()
            .email({ minDomainSegments: 2, tlds: { allow: ["com", "net", "org", "edu"] } })
            .required()
            .trim()
            .required(),
        password: Joi.string().min(8).trim().required(),
        firstName: Joi.string().required(),
        lastName: Joi.string().required(),
        receiptDate: Joi.string().required(),
    });

    const { error } = schema.validate(user);
    if (error) return res.status(400).json(error.details);

    const emailInUse = (await ddbClient.get({TableName: "ShopPal", Key: { email: user.email, receiptDate: "profile" }}).promise())
    if (Object.keys(emailInUse).length == 1) return res.json("Email already exists.")

    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(user.password, salt);

    const params = {
        TableName: "ShopPal",
        Item: user,
    }

    return res.json(await ddbClient.put(params).promise());

});

router.post("/login", async (req, res) => {

});

module.exports = router;