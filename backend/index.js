const express = require("express");
const bodyParser = require("body-parser");

const userRoute = require("./routes/user");
const receiptRoute = require("./routes/receipt");
const historyRoute = require("./routes/history");
const auth = require("./middleware/auth");

const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req, res) => { 
    res.send("Shop Pal API");
});

app.use("/user", userRoute);
app.use("/receipt", auth, receiptRoute);
app.use("/history", auth, historyRoute);

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log("Server is running on port " + port);
});
