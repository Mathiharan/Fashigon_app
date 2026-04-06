const { port: PORT, mongodbUri: DB } = require('./config/env');
const express = require('express');
const cors = require('cors');
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
const bannerRouter = require('./routes/banner');
const categoryRouter = require('./routes/category');
const subCategoryRouter = require('./routes/sub_category');
const productRouter = require('./routes/product');
const productReviewRouter = require('./routes/product_review');
const vendorRouter = require('./routes/vendor');
const orderRouter = require('./routes/order');
const helloRouter = require('./routes/hello');
// Create an instance of an Express application
// because it gives us the starting point for building our web server
const app = express();

// Enable CORS for all routes and origins.
app.use(cors());

//middleware - to register routes or to mount routes
app.use(express.json());
app.use(cors()); // enable CORS for all routes and origin
app.use(helloRouter);
app.use(authRouter);
app.use(bannerRouter);
app.use(categoryRouter);
app.use(subCategoryRouter);
app.use(productRouter);
app.use(productReviewRouter);
app.use(vendorRouter);
app.use(orderRouter);

mongoose.connect(DB, { useNewUrlParser: true, useUnifiedTopology: true, serverSelectionTimeoutMS: 5000 })
    .then(() => {
        console.log("Mongodb connected");
    })
    .catch((err) => {
        console.error("Failed to connect to MongoDB. Error details:");
        console.error("Error message:", err.message);
        console.error("Stack trace:", err.stack);
        console.error("Ensure the connection string is correct and accessible.");
    });

// Start the server and listen on the specified port
app.listen(PORT, () => {
    // Log a message to the console when the server starts
    console.log(`App listening on port ${PORT}!`);
});

