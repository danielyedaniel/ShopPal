const bcrypt = require("bcrypt");
const Joi = require("joi");
const ddbClient = require("../dynamo");

const auth = async (req, res, next) => {
    const schema = Joi.object({
        email: Joi.string()
            .email({ minDomainSegments: 2, tlds: { allow: ["com", "net", "org", "edu"] } })
            .required()
            .trim(),
        password: Joi.string().min(8).trim(),
    });
    const { error } = schema.validate({ email: req.body.email, password: req.body.password });
    if (error) return res.status(400).json(error.details);

    const user = (await ddbClient.get({TableName: "ShopPal", Key: { email: req.body.email, receiptDate: "profile" }}).promise())
    if (Object.keys(user).length == 0) return res.status(400).json("Wrong email or password")

    const validPassword = await bcrypt.compare(req.body.password, user.Item.password);
    if (!validPassword) return res.status(400).json("Wrong email or password");

    next();
}

module.exports = auth;