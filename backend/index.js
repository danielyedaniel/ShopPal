const express = require("express");
const bodyParser = require("body-parser");
const multer = require("multer");

const userRoute = require("./routes/user");
const receiptRoute = require("./routes/receipt");
const historyRoute = require("./routes/history");
const auth = require("./middleware/auth");

const upload = multer({ dest: 'receiptParser/' });

process.on("uncaughtException", (err, origin) => {
    console.log("Uncaught Exception:", err, "Origin", origin);
});

process.on("unhandledRejection", (reason, promise) => {
    console.log("Unhandled Rejection at:", promise, "reason:", reason);
});

const app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.get("/", (req, res) => { 
    res.send("Shop Pal API");
});

app.use("/user", userRoute);
app.use("/receipt", upload.single('file'), auth, receiptRoute); // auth is in file
app.use("/history", auth, historyRoute);

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log("Server is running on port " + port);
});
