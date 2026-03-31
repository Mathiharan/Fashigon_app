const mognoose = require("mongoose");

const subCategorySchema = new mognoose.Schema({
    categoryId: {
        type: String,
        required: true,
    },

    categoryName: {
        type: String,
        required: true,
    },

    image: {
        type: String,
        required: true,
    },

    subCategoryName: {
        type: String,
        required: true,
    },
});

const subCategory = mognoose.model("SubCategory", subCategorySchema);
module.exports = subCategory;