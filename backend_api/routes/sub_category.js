const express = require('express');
const SubCategory = require('../models/sub_category');
const subCategoryRouter = express.Router();

subCategoryRouter.post('/api/subcategories', async (req, res) => {
    try {
        const { categoryId, categoryName, image, subCategoryName } = req.body;
        const subCategory = new SubCategory({ categoryId, categoryName, image, subCategoryName });
        await subCategory.save();
        res.status(201).send(subCategory);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

subCategoryRouter.get('/api/subcategories', async (req, res) => {
    try {
        const subCategories = await SubCategory.find();
        // Send the response in MAP-JSON format.
        return res.status(200).send(subCategories);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

subCategoryRouter.get('/api/category/:categoryName/subcategories', async (req, res) => {
    try {
        //extract the categoryName from the request Url using Destructing
        const { categoryName } = req.params;

        const subCategories = await SubCategory.find({ categoryName: categoryName });

        //check if any subcategories were found
        if (!subCategories || subCategories.length == 0) {
            //if no subcategories were found, return a 404 error
            return res.status(404).json({ message: 'No subcategories found for this category' });
        } else {
            return res.status(200).json(subCategories);
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = subCategoryRouter;