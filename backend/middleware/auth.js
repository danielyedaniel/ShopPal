const bcrypt = require("bcrypt");

const auth = (req, res, next) => {
    const email = req.body.email;
    const password = req.body.password;

    if (!email || !password) {
        const err = new Error("Email and password are required.");
        err.status = 400;
        return next(err);
    }

    // Do something to check if the user is authenticated
    next();
}

module.exports = auth;