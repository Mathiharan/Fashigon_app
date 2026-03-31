const express = require("express");

const Order = require('../models/order');

const orderRouter = express.Router();

const { auth, vendorAuth } = require('../middleware/auth');

orderRouter.post('/api/orders', async (req, res) => {
    try {
        const { fullName, email, state, city, locality, productName, productPrice, quantity, category, image, buyerId, vendorId, } = req.body;
        const createdAt = new Date().getMilliseconds();
        const order = new Order({ fullName, email, state, city, locality, productName, productPrice, quantity, category, image, buyerId, vendorId, createdAt });

        await order.save();
        // Will send the list in pure array format.
        return res.status(201).json(order);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// GET Route for fetching orders by buyer ID.
orderRouter.get('/api/orders/:buyerId', async (req, res) => {
    try {
        // Extract the buyerId from the request parameters
        const { buyerId } = req.params;
        //Find all orders in the database that match the buyerId
        const orders = await Order.find({ buyerId });
        // If no orders are found, return a 404 status with a message.
        if (orders.length == 0) {
            return res.status(404).json({ msg: "No Orders found for this buyer" });
        }
        // If orders are found, return them with a 200 status code.
        return res.status(200).json(orders);
    } catch (e) {
        // Handle any errors that occur during the order retrieval process.
        res.status(500).json({ error: e.message });
    }
});

// Delete route for deleting a specific order by _id.

orderRouter.delete('/api/orders/:id', auth, async (req, res) => {
    try {
        // Extract the id from the request parameter.
        const { id } = req.params;
        // Find and delete the order from the database using the extracted _id.
        const deletedOrder = await Order.findByIdAndDelete(id);
        // If no order is found, return a 404 status with a message.
        if (!deletedOrder) {
            return res.status(404).json({ msg: "Order not found" });
        }
        // If the order is found and deleted, return a 200 status with a success message.
        return res.status(200).json({ msg: "Order deleted successfully" });
    } catch (error) {
        // Handle any errors that occur during the order deletion process.
        res.status(500).json({ error: error.message });
    }
});

// GET Route for fetching orders by vendor ID.
orderRouter.get('/api/orders/vendors/:vendorId', auth, vendorAuth, async (req, res) => {
    try {
        // Extract the vendorId from the request parameters
        const { vendorId } = req.params;
        //Find all orders in the database that match the vendorId
        const orders = await Order.find({ vendorId });
        // If no orders are found, return a 404 status with a message.
        if (orders.length == 0) {
            return res.status(404).json({ msg: "No Orders found for this vendor" });
        }
        // If orders are found, return them with a 200 status code.
        return res.status(200).json(orders);
    } catch (e) {
        // Handle any errors that occur during the order retrieval process.
        res.status(500).json({ error: e.message });
    }
});

orderRouter.patch('/api/orders/:id/delivered', async (req, res) => {
    try {
        const { id } = req.params;
        const updateOrder = await Order.findByIdAndUpdate(
            id,
            { delivered: true, processing: false },
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
            { processing: false, delivered: false },
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

orderRouter.get('/api/orders', async (req, res) => {
    try {
        const orders = await Order.find();
        if (orders.length === 0) {
            return res.status(404).json({ msg: "No Orders found" });
        }
        return res.status(200).json(orders);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = orderRouter;

