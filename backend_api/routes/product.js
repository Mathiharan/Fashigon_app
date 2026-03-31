const express = require('express');
const Product = require('../models/product');
const productRouter = express.Router();
const { auth, vendorAuth } = require('../middleware/auth');

productRouter.post('/api/add-product', auth, vendorAuth, async (req, res) => {
    try {
        const { productName, productPrice, quantity, description, category, vendorId, fullName, subCategory, images } = req.body;
        const product = new Product({ productName, productPrice, quantity, description, category, vendorId, fullName, subCategory, images });
        await product.save();
        res.status(201).send(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


productRouter.get('/api/popular-products', async (req, res) => {
    try {
        const product = await Product.find({ popular: true });
        if (!product || product.length == 0) {
            return res.status(404).json({ message: 'Products not found' });
        } else {
            return res.status(200).json(product);
        }
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});

productRouter.get('/api/recommended-products', async (req, res) => {
    try {
        const product = await Product.find({ recommend: true });
        if (!product || product.length == 0) {
            return res.status(404).json({ message: 'Products not found' });
        } else {
            return res.status(200).json(product);
        }
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//new route for retrieving products by category
productRouter.get('/api/products-by-category/:category', async (req, res) => {
    try {
        const category = req.params.category;
        const products = await Product.find({ category, popular: true });
        if (!products || products.length == 0) {
            return res.status(404).json({ message: 'Products not found' });
        } else {
            return res.status(200).json(products);
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
}
);

// New route for retrieving products by sub-category
productRouter.get('/api/related-products-by-subcategory/:productId', async (req, res) => {
    try {
        const { productId } = req.params;
        // First, find the product to get its subcategory
        const product = await Product.findById(productId);
        if (!product) {
            return res.status(404).json({ msg: 'Product not found' });
        }
        else {
            // Find related products based on the subcategory of the retrieved product
            await Product.find({ subCategory: product.subCategory, _id: { $ne: productId } })
                .then(relatedProducts => {
                    if (!relatedProducts || relatedProducts.length === 0) {
                        return res.status(404).json({ msg: 'No related products found' });
                    }
                    return res.status(200).json(relatedProducts);
                })
                .catch(err => {
                    return res.status(500).json({ error: err.message });
                });
        }
    } catch (error) {
        res.status(500).json({ error: error.msg });
    }
});

// Route to retrieving the top 10 highest-rated products

productRouter.get('/api/top-rated-products', async (req, res) => {
    try {
        // Fetch all products and sort them by averageRating in descending order, limit to 10
        const topRatedProducts = await Product.find().sort({ averageRating: -1 }).limit(10);
        if (!topRatedProducts || topRatedProducts.length === 0) {
            return res.status(404).json({ msg: 'No top-rated products found' });
        }
        return res.status(200).json(topRatedProducts);
    } catch (error) {
        res.status(500).json({ error: error.msg });
    }
});

productRouter.get('/api/products-by-subcategory/:subCategory', async (req, res) => {
    try {
        const { subCategory } = req.params;
        const products = await Product.find({ subCategory });
        if (!products || products.length === 0) {
            return res.status(404).json({ msg: 'No products found for this sub-category' });
        }
        return res.status(200).json(products);
    } catch (error) {
        res.status(500).json({ error: error.msg });
    }
});

// Route for searching products by name or description

productRouter.get('/api/search-products', async (req, res) => {
    try {
        // Extract the 'query' parameter from the request query string
        const { query } = req.query;
        // Validate that a query parameter is provided;
        // If missing, return a 400 status with an error message.

        if (!query) {
            return res.status(400).json({ error: 'Search query is required' });
        }

        // Search for the product collection for documents where either 'ProductName' or 'description'
        // Contains the specified query String;

        const products = await Product.find({
            $or: [
                // Regex will match any productName containing the query String,
                // For example, if the user search for "apple", the regex with check
                // if "apple" is part of any productName, so product name "Green Apple pie",
                // Or "Fresh Apples", would all match because they contain the world "apple"
                { productName: { $regex: query, $options: 'i' } },
                { description: { $regex: query, $options: 'i' } }
            ]
        });

        // Check if any products were found
        if (!products || products.length === 0) {
            return res.status(404).json({ msg: 'No products found' });
        }

        // if product are found, return 200
        return res.status(200).json(products);

    } catch (error) {
        res.status(500).json({ error: error.msg });
    }
});

module.exports = productRouter;