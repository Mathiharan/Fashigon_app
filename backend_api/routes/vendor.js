const express = require('express');
const Vendor = require('../models/vendor');
const vendorRouter = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { jwtSecret } = require('../config/env');

vendorRouter.post('/api/vendor/signup', async (req, res) => {
    try {
        const { FullName, email, password } = req.body;

        const existingEmail = await Vendor.findOne({ email });
        if (existingEmail) {
            return res.status(400).json({ message: "Vendor with same email already exists" });
        }
        else {
            // Generate a salt with a cost factor of 10.
            const salt = await bcrypt.genSalt(10);
            // Hash the password using the generated salt.
            const hashedPassword = await bcrypt.hash(password, salt);
            console.log("Hashed Password:", hashedPassword); // Debugging log
            console.log("User Data:", { FullName, email }); // Debugging log
            let vendor = new Vendor({ FullName, email, password: hashedPassword });
            vendor = await vendor.save();
            res.json({ vendor });
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Signin API endpoint.

vendorRouter.post('/api/vendor/signin', async (req, res) => {
    try {
        const { email, password } = req.body;
        const findUser = await Vendor.findOne({ email });
        if (!findUser) {
            return res.status(400).json({ message: "Vendor not found with this email" });
        }
        else {
            await bcrypt.compare(password, findUser.password).then((isMatch) => {
                if (isMatch) {
                    const token = jwt.sign({ id: findUser._id }, jwtSecret);

                    // Extract the password from the document (user from mongodb), and everything else except
                    // password will be stored into userWithoutPassword. (remove sensitive info)
                    const { password, ...vendorWithoutPassword } = findUser._doc;

                    // Send the token and user data in the response.
                    res.json({ token, vendor: vendorWithoutPassword });
                } else {
                    res.status(400).json({ message: "Incorrect Password" });
                }
            });
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Fetch all vendors (exclude password)
vendorRouter.get('/api/vendors', async (req, res) => {
    try {
        const vendors = await Vendor.find().select('-password'); // Exclude password field
        return res.status(200).json(vendors);
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

module.exports = vendorRouter;