const express = require("express");

const helloRoute = express.Router();

helloRoute.get("/hello", (req, res) => {
    // Send a simple text response when the "/hello" route is accessed
    res.send("Hello World!");
});

module.exports = helloRoute;