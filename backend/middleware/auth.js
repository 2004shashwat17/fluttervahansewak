const jwt = require('jsonwebtoken');
const User = require('../models/User');

const auth = async (req, res, next) => {
  try {
    const token = req.header('Authorization')?.replace('Bearer ', '');
    
    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'No token provided, authorization denied',
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.id).select('-password');
    
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Token is not valid',
      });
    }

    req.user = user;
    next();
  } catch (error) {
    console.error('Auth middleware error:', error);
    res.status(401).json({
      success: false,
      message: 'Token is not valid',
    });
  }
};

// Middleware to check if user is a mechanic
const isMechanic = (req, res, next) => {
  if (req.user.type !== 'mechanic') {
    return res.status(403).json({
      success: false,
      message: 'Access denied. Mechanic role required.',
    });
  }
  next();
};

// Middleware to check if user is a customer
const isCustomer = (req, res, next) => {
  if (req.user.type !== 'customer') {
    return res.status(403).json({
      success: false,
      message: 'Access denied. Customer role required.',
    });
  }
  next();
};

module.exports = { auth, isMechanic, isCustomer };