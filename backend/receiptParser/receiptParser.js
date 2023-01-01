const fs = require('fs');
const { Configuration, OpenAIApi } = require("openai");
const Tesseract =  require('tesseract.js');
require("dotenv").config();

const configuration = new Configuration({
    apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);

const parseReceipt = async (fileName) => {
    const receiptImagePath = './receiptParser/' + fileName;

    const text = (await Tesseract.recognize(receiptImagePath, 'eng')).data.text;

    const response = await openai.createCompletion({
        model: 'text-davinci-003',
        prompt: `Parse this receipt and return the store name, address, date of purchase, name and price of each item, 
        and total as a JavaScript JSON object. Do not include any extra information or characters in the JSON. 
        Do not include the subtotal, tax, cashtend, or changegiven. If you are unsure about the date, use today's date in iso date format. 
        Format the dateOfPurchase in iso date format. If you are unsure about any of the properties, set it to unknown.
        Do not combine items with the same name. If you are unsure about the price, set it to 0.00.
        Text: ${text}`,
        temperature: 0,
        max_tokens: 2048,
        top_p: 1,
        frequency_penalty: 0,
        presence_penalty: 0
    });

    const items = response.data.choices[0].text;

    fs.unlinkSync('./receiptParser/' + fileName);

    return items;
}

// parseReceipt().then(items => {
//   console.log(items);
// });

module.exports = parseReceipt;