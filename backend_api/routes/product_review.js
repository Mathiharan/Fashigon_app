const express = require('express');
const ProductReview = require('../models/product_review');
const Product = require('../models/product'); // Import Product model to find products by ID

const productReviewRouter = express.Router();

productReviewRouter.post('/api/product-review', async (req, res) => {
    try {
        const { buyerId, email, fullName, productId, rating, review } = req.body;
        // Check if the user has already reviewed the product.
        const existingReview = await ProductReview.findOne({ buyerId, productId });
        if (existingReview) {
            return res.status(400).json({ message: 'You have already reviewed this product.' });
        }

        const productReview = new ProductReview({ buyerId, email, fullName, productId, rating, review });
        await productReview.save();

        // Find the product associated with the review using the productId.
        const product = await Product.findById(productId);
        // If the product was not found, return a 404 error response
        if (!product) {
            return res.status(404).json({ message: 'Product not found' });
        }

        // Initialize totalRatings and averageRating if undefined
        if (typeof product.totalRatings !== 'number') {
            product.totalRatings = 0;
        }
        if (typeof product.averageRating !== 'number') {
            product.averageRating = 0;
        }

        // Update the totalRatings by increment it by 1
        console.log('Product Total Ratings:', product.totalRatings);
        product.totalRatings += 1;
        console.log('Product Total Ratings:', product.totalRatings);

        product.averageRating = (
            (product.averageRating * (product.totalRatings - 1) + rating) / product.totalRatings
        );

        // Save the updated product
        await product.save();

        return res.status(201).send(productReview);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

productReviewRouter.get('/api/reviews', async (req, res) => {
    try {
        const reviews = await ProductReview.find();
        return res.status(200).json(reviews);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = productReviewRouter;