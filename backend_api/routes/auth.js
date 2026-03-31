const express = require('express');
const User = require('../models/user');
const bcrypt = require('bcryptjs');
const authRouter = express.Router();
const orderRouter = require('./order'); // Importing orderRouter to use in authRouter
const jwt = require('jsonwebtoken');

authRouter.post('/api/signup', async (req, res) => {
    try {
        const { FullName, email, state, city, locality, password } = req.body;

        const existingEmail = await User.findOne({ email });
        if (existingEmail) {
            return res.status(400).json({ message: "Email already exists" });
        }
        else {
            // Generate a salt with a cost factor of 10.
            const salt = await bcrypt.genSalt(10);
            // Hash the password using the generated salt.
            const hashedPassword = await bcrypt.hash(password, salt);
            console.log("Hashed Password:", hashedPassword); // Debugging log
            console.log("User Data:", { FullName, email }); // Debugging log
            let user = new User({ FullName, email, password: hashedPassword });
            user = await user.save();
            res.json({ user });
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Signin API endpoint.

authRouter.post('/api/signin', async (req, res) => {
    try {
        const { email, password } = req.body;
        const findUser = await User.findOne({ email });
        if (!findUser) {
            return res.status(400).json({ message: "User not found with this email" });
        }
        else {
            await bcrypt.compare(password, findUser.password).then((isMatch) => {
                if (isMatch) {
                    const token = jwt.sign({ id: findUser._id }, "passwordKey");

                    // Extract the password from the document (user from mongodb), and everything else except
                    // password will be stored into userWithoutPassword. (remove sensitive info)
                    const { password, ...userWithoutPassword } = findUser._doc;

                    // Send the token and user data in the response.
                    res.json({ token, user: userWithoutPassword });
                } else {
                    res.status(400).json({ message: "Incorrect Password" });
                }
            });
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Put route for updating user's state, city and locality
authRouter.put('/api/users/:id', async (req, res) => {
    try {
        // Extract the 'id' parameter from the request URL
        const { id } = req.params;
        //Extract the "state", "city" and locality fields from the request body.
        const { state, city, locality } = req.body;
        // Find the user by their ID and update the state, city and locality fields
        // the {new:true} option ensures the updated document is returned.
        const updatedUser = await User.findByIdAndUpdate(
            id,
            { state, city, locality },
            { new: true },
        );

        // If No user is found, return 404 page not found status with an error message.
        if (!updatedUser) {
            return res.status(404).json({ error: "User not founds" });
        }
        return res.status(200).json(updatedUser);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Fetch all users(exclude password)

authRouter.get('/api/users', async (req, res) => {
    try {
        const users = await User.find().select('-password');
         // Exclude password field
        return res.status(200).json(users);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

orderRouter.patch('/api/orders/:id/delivered', async (req, res) => {
    try {
        const { id } = req.params;
        const updateOrder = await Order.findByIdAndUpdate(
            id,
            { delivered: true },
            { new: true }
        );
        if (!updateOrder) {
            return res.status(404).json({ msg: "Order not found" });
        } else {
            return res.status(200).json({ updateOrder });
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

orderRouter.patch('/api/orders/:id/processing', async (req, res) => {
    try {
        const { id } = req.params;
        const updateOrder = await Order.findByIdAndUpdate(
            id,
            { processing: false },
            { new: true }
        );
        if (!updateOrder) {
            return res.status(404).json({ msg: "Order not found" });
        } else {
            return res.status(200).json({ updateOrder });
        }
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});



module.exports = authRouter;