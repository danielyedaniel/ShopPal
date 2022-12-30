const express = require("express");

const router = express.Router();

router.post("/add", async (req, res) => {
    return res.json("added")
});

router.post("/delete", async (req, res) => {

});

module.exports = router;