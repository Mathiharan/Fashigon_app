const jwt = require('jsonwebtoken');
const User = require('../models/user');
const Vendor = require('../models/vendor');

// authentication middleware to verify JWT token
// this middleware function checks if the user is authenticated

const auth = async (req, res, next) => {
    try {
        // extract the token from the request headers
        const token = req.header('x-auth-token');

        // if no token is provided, return 401(unauthorized) response with an error message.

        if (!token) return res.status(401).json({ msg: "No authentication token, authorization denied." });

        // Verify the jwt token using the secret key
        const verified = jwt.verify(token, "passwordKey");
        // If the token verification failed, return 401,
        if (!verified) return res.status(401).json({ msg: "Token verification failed, authorization denied." });

        // Find the normal user or vendor in the database using the id stored in the token payload.

        const user = await User.findById(verified.id) || await Vendor.findById(verified.id);

        if (!user) return res.status(401).json({ msg: "User or Vendor not found, authorization denied." });

        // Attach the authenticated user (whether a normal user or a vendor ) to the request objects,
        // this makes the user's data available to any subsequent middleware or route handlers.

        req.user = user;

        // Also attract the token to the request object in case is needed later
        req.token = token;

        // proceed to the next middleware or route handler
        next();
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Vendor Authentication middleware.
// This middleware ensures that the user making the request is a vendor.
// It should be used for routes that only vendor can access.

const vendorAuth = (req, res, next) => {
    try {
        // Check if the user making the request is a vendor (by checking the "role" property)
        if (!req.user.role || req.user.role !== "vendor") {
            return res.status(403).json({ msg: "Access denied, vendor only resource." });
        }

        // If the user is a vendor, proceed to the next middleware or route handler.
        next();
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
};

module.exports = { auth, vendorAuth };