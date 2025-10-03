const express = require('express');
const Mechanic = require('../models/Mechanic');
const User = require('../models/User');
const { auth, isMechanic } = require('../middleware/auth');

const router = express.Router();

// @route   GET /api/mechanics/nearby
// @desc    Get nearby mechanics
// @access  Private
router.get('/nearby', auth, async (req, res) => {
  try {
    const { lat, lng, radius = 10 } = req.query;

    if (!lat || !lng) {
      return res.status(400).json({
        success: false,
        message: 'Latitude and longitude are required',
      });
    }

    const mechanics = await Mechanic.find({
      isOnline: true,
      isVerified: true,
      currentLocation: {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [parseFloat(lng), parseFloat(lat)]
          },
          $maxDistance: parseFloat(radius) * 1000 // Convert km to meters
        }
      }
    })
    .populate('userId', 'name phone email profileImage')
    .sort({ rating: -1 })
    .limit(20);

    res.status(200).json({
      success: true,
      count: mechanics.length,
      data: mechanics,
    });
  } catch (error) {
    console.error('Get nearby mechanics error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   PUT /api/mechanics/:id/location
// @desc    Update mechanic location
// @access  Private (Mechanic only)
router.put('/:id/location', auth, isMechanic, async (req, res) => {
  try {
    const { latitude, longitude, address } = req.body;

    const mechanic = await Mechanic.findOne({ userId: req.user._id });

    if (!mechanic) {
      return res.status(404).json({
        success: false,
        message: 'Mechanic profile not found',
      });
    }

    mechanic.currentLocation = {
      type: 'Point',
      coordinates: [longitude, latitude],
      address,
      lastUpdated: new Date(),
    };

    await mechanic.save();

    res.status(200).json({
      success: true,
      message: 'Location updated successfully',
      data: mechanic.currentLocation,
    });
  } catch (error) {
    console.error('Update location error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   PUT /api/mechanics/:id/status
// @desc    Update mechanic online status
// @access  Private (Mechanic only)
router.put('/:id/status', auth, isMechanic, async (req, res) => {
  try {
    const { isOnline } = req.body;

    const mechanic = await Mechanic.findOne({ userId: req.user._id });

    if (!mechanic) {
      return res.status(404).json({
        success: false,
        message: 'Mechanic profile not found',
      });
    }

    mechanic.isOnline = isOnline;
    await mechanic.save();

    res.status(200).json({
      success: true,
      message: `Status updated to ${isOnline ? 'online' : 'offline'}`,
      data: { isOnline },
    });
  } catch (error) {
    console.error('Update status error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   GET /api/mechanics/profile
// @desc    Get mechanic profile
// @access  Private (Mechanic only)
router.get('/profile', auth, isMechanic, async (req, res) => {
  try {
    const mechanic = await Mechanic.findOne({ userId: req.user._id })
      .populate('userId', 'name phone email profileImage');

    if (!mechanic) {
      return res.status(404).json({
        success: false,
        message: 'Mechanic profile not found',
      });
    }

    res.status(200).json({
      success: true,
      data: mechanic,
    });
  } catch (error) {
    console.error('Get mechanic profile error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   PUT /api/mechanics/profile
// @desc    Update mechanic profile
// @access  Private (Mechanic only)
router.put('/profile', auth, isMechanic, async (req, res) => {
  try {
    const updateData = req.body;
    delete updateData.userId; // Prevent updating userId
    delete updateData.rating; // Prevent manual rating updates
    delete updateData.totalJobs; // Prevent manual job count updates

    const mechanic = await Mechanic.findOneAndUpdate(
      { userId: req.user._id },
      updateData,
      { new: true, runValidators: true }
    ).populate('userId', 'name phone email profileImage');

    if (!mechanic) {
      return res.status(404).json({
        success: false,
        message: 'Mechanic profile not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
      data: mechanic,
    });
  } catch (error) {
    console.error('Update mechanic profile error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   POST /api/mechanics/:id/review
// @desc    Add review for mechanic
// @access  Private
router.post('/:id/review', auth, async (req, res) => {
  try {
    const { rating, comment, requestId } = req.body;
    const mechanicId = req.params.id;

    const mechanic = await Mechanic.findById(mechanicId);

    if (!mechanic) {
      return res.status(404).json({
        success: false,
        message: 'Mechanic not found',
      });
    }

    // Check if user already reviewed this mechanic for this request
    const existingReview = mechanic.reviews.find(
      review => review.customerId.toString() === req.user._id.toString() &&
                review.requestId.toString() === requestId
    );

    if (existingReview) {
      return res.status(400).json({
        success: false,
        message: 'You have already reviewed this mechanic for this request',
      });
    }

    mechanic.reviews.push({
      customerId: req.user._id,
      requestId,
      rating,
      comment,
    });

    await mechanic.save();

    res.status(201).json({
      success: true,
      message: 'Review added successfully',
      data: mechanic.reviews[mechanic.reviews.length - 1],
    });
  } catch (error) {
    console.error('Add review error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   GET /api/mechanics/:id/reviews
// @desc    Get mechanic reviews
// @access  Public
router.get('/:id/reviews', async (req, res) => {
  try {
    const mechanic = await Mechanic.findById(req.params.id)
      .populate('reviews.customerId', 'name profileImage')
      .select('reviews rating');

    if (!mechanic) {
      return res.status(404).json({
        success: false,
        message: 'Mechanic not found',
      });
    }

    res.status(200).json({
      success: true,
      count: mechanic.reviews.length,
      averageRating: mechanic.rating,
      data: mechanic.reviews.sort((a, b) => b.createdAt - a.createdAt),
    });
  } catch (error) {
    console.error('Get reviews error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   GET /api/mechanics/search
// @desc    Search mechanics by specialization, location, etc.
// @access  Private
router.get('/search', auth, async (req, res) => {
  try {
    const { specialization, minRating, maxDistance, lat, lng } = req.query;

    let query = {
      isOnline: true,
      isVerified: true,
    };

    if (specialization) {
      query.specialization = new RegExp(specialization, 'i');
    }

    if (minRating) {
      query.rating = { $gte: parseFloat(minRating) };
    }

    let mechanics;

    if (lat && lng) {
      const distance = maxDistance ? parseFloat(maxDistance) * 1000 : 10000; // Default 10km

      mechanics = await Mechanic.find({
        ...query,
        currentLocation: {
          $near: {
            $geometry: {
              type: 'Point',
              coordinates: [parseFloat(lng), parseFloat(lat)]
            },
            $maxDistance: distance
          }
        }
      })
      .populate('userId', 'name phone email profileImage')
      .sort({ rating: -1 })
      .limit(50);
    } else {
      mechanics = await Mechanic.find(query)
        .populate('userId', 'name phone email profileImage')
        .sort({ rating: -1 })
        .limit(50);
    }

    res.status(200).json({
      success: true,
      count: mechanics.length,
      data: mechanics,
    });
  } catch (error) {
    console.error('Search mechanics error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

module.exports = router;