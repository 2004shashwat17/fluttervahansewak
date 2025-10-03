const express = require('express');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const Mechanic = require('../models/Mechanic');

const router = express.Router();

// Generate JWT Token
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE,
  });
};

// @route   POST /api/auth/register
// @desc    Register user
// @access  Public
router.post('/register', async (req, res) => {
  try {
    const { name, phone, email, password, type } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({
      $or: [{ email }, { phone }]
    });

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'User already exists with this email or phone',
      });
    }

    // Create user
    const user = await User.create({
      name,
      phone,
      email,
      password,
      type,
    });

    // If user is a mechanic, create mechanic profile
    if (type === 'mechanic') {
      await Mechanic.create({
        userId: user._id,
        specialization: 'General Mechanic',
        experienceYears: 0,
        pricePerHour: 500,
      });
    }

    const token = generateToken(user._id);

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      token,
      user: user.toJSON(),
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   POST /api/auth/login
// @desc    Login user
// @access  Public
router.post('/login', async (req, res) => {
  try {
    const { phone, password } = req.body;

    // Check if user exists and include password
    const user = await User.findOne({ phone }).select('+password');

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }

    // Check password
    const isPasswordMatch = await user.matchPassword(password);

    if (!isPasswordMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
      });
    }

    const token = generateToken(user._id);

    res.status(200).json({
      success: true,
      message: 'Login successful',
      token,
      user: user.toJSON(),
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   POST /api/auth/verify-phone
// @desc    Verify phone number with OTP
// @access  Public
router.post('/verify-phone', async (req, res) => {
  try {
    const { phone, otp } = req.body;
    
    // Here you would typically verify the OTP with Twilio
    // For demo purposes, we'll accept any 4-digit OTP
    if (otp && otp.length === 4) {
      res.status(200).json({
        success: true,
        message: 'Phone number verified successfully',
      });
    } else {
      res.status(400).json({
        success: false,
        message: 'Invalid OTP',
      });
    }
  } catch (error) {
    console.error('Phone verification error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   POST /api/auth/send-otp
// @desc    Send OTP to phone number
// @access  Public
router.post('/send-otp', async (req, res) => {
  try {
    const { phone } = req.body;
    
    // Here you would typically send OTP via Twilio
    // For demo purposes, we'll just return success
    res.status(200).json({
      success: true,
      message: 'OTP sent successfully',
      otp: '1234', // Don't send this in production!
    });
  } catch (error) {
    console.error('Send OTP error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

module.exports = router;