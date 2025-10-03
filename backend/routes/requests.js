const express = require('express');
const ServiceRequest = require('../models/ServiceRequest');
const Mechanic = require('../models/Mechanic');
const { auth, isCustomer, isMechanic } = require('../middleware/auth');

const router = express.Router();

// @route   POST /api/requests
// @desc    Create a new service request
// @access  Private (Customer only)
router.post('/', auth, isCustomer, async (req, res) => {
  try {
    const requestData = {
      ...req.body,
      customerId: req.user._id,
    };

    const serviceRequest = await ServiceRequest.create(requestData);
    await serviceRequest.populate('customerId', 'name phone');

    res.status(201).json({
      success: true,
      message: 'Service request created successfully',
      data: serviceRequest,
    });
  } catch (error) {
    console.error('Create request error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   GET /api/requests/customer/:customerId
// @desc    Get all requests for a customer
// @access  Private
router.get('/customer/:customerId', auth, async (req, res) => {
  try {
    const requests = await ServiceRequest.find({
      customerId: req.params.customerId
    })
    .populate('mechanicId', 'name phone')
    .sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: requests.length,
      data: requests,
    });
  } catch (error) {
    console.error('Get customer requests error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   GET /api/requests/nearby
// @desc    Get nearby service requests for mechanics
// @access  Private (Mechanic only)
router.get('/nearby', auth, isMechanic, async (req, res) => {
  try {
    const { lat, lng, radius = 10 } = req.query;

    if (!lat || !lng) {
      return res.status(400).json({
        success: false,
        message: 'Latitude and longitude are required',
      });
    }

    const requests = await ServiceRequest.find({
      status: 'pending',
      customerLocation: {
        $near: {
          $geometry: {
            type: 'Point',
            coordinates: [parseFloat(lng), parseFloat(lat)]
          },
          $maxDistance: parseFloat(radius) * 1000 // Convert km to meters
        }
      }
    })
    .populate('customerId', 'name phone')
    .sort({ createdAt: -1 })
    .limit(20);

    // Add distance calculation
    const requestsWithDistance = requests.map(request => {
      const distance = request.distanceFrom(parseFloat(lng), parseFloat(lat));
      return {
        ...request.toObject(),
        distance: distance.toFixed(2)
      };
    });

    res.status(200).json({
      success: true,
      count: requestsWithDistance.length,
      data: requestsWithDistance,
    });
  } catch (error) {
    console.error('Get nearby requests error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   PUT /api/requests/:id/accept
// @desc    Accept a service request
// @access  Private (Mechanic only)
router.put('/:id/accept', auth, isMechanic, async (req, res) => {
  try {
    const request = await ServiceRequest.findById(req.params.id);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Service request not found',
      });
    }

    if (request.status !== 'pending') {
      return res.status(400).json({
        success: false,
        message: 'Request is no longer available',
      });
    }

    // Get mechanic profile
    const mechanic = await Mechanic.findOne({ userId: req.user._id });
    if (!mechanic) {
      return res.status(404).json({
        success: false,
        message: 'Mechanic profile not found',
      });
    }

    request.mechanicId = req.user._id;
    request.status = 'accepted';
    request.acceptedAt = new Date();
    await request.save();

    // Update mechanic stats
    mechanic.totalJobs += 1;
    await mechanic.save();

    await request.populate([
      { path: 'customerId', select: 'name phone' },
      { path: 'mechanicId', select: 'name phone' }
    ]);

    res.status(200).json({
      success: true,
      message: 'Request accepted successfully',
      data: request,
    });
  } catch (error) {
    console.error('Accept request error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   PUT /api/requests/:id/complete
// @desc    Complete a service request
// @access  Private (Mechanic only)
router.put('/:id/complete', auth, isMechanic, async (req, res) => {
  try {
    const { finalCost } = req.body;
    const request = await ServiceRequest.findById(req.params.id);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Service request not found',
      });
    }

    if (request.mechanicId.toString() !== req.user._id.toString()) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to complete this request',
      });
    }

    request.status = 'completed';
    request.finalCost = finalCost;
    request.completedAt = new Date();
    await request.save();

    // Update mechanic stats
    const mechanic = await Mechanic.findOne({ userId: req.user._id });
    if (mechanic) {
      mechanic.completedJobs += 1;
      mechanic.earnings.thisMonth += finalCost;
      mechanic.earnings.total += finalCost;
      await mechanic.save();
    }

    res.status(200).json({
      success: true,
      message: 'Request completed successfully',
      data: request,
    });
  } catch (error) {
    console.error('Complete request error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   PUT /api/requests/:id/cancel
// @desc    Cancel a service request
// @access  Private
router.put('/:id/cancel', auth, async (req, res) => {
  try {
    const request = await ServiceRequest.findById(req.params.id);

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Service request not found',
      });
    }

    // Check if user is authorized to cancel
    const isCustomer = request.customerId.toString() === req.user._id.toString();
    const isMechanic = request.mechanicId?.toString() === req.user._id.toString();

    if (!isCustomer && !isMechanic) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to cancel this request',
      });
    }

    request.status = 'cancelled';
    await request.save();

    res.status(200).json({
      success: true,
      message: 'Request cancelled successfully',
      data: request,
    });
  } catch (error) {
    console.error('Cancel request error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

// @route   GET /api/requests/:id
// @desc    Get single request details
// @access  Private
router.get('/:id', auth, async (req, res) => {
  try {
    const request = await ServiceRequest.findById(req.params.id)
      .populate('customerId', 'name phone email')
      .populate('mechanicId', 'name phone email');

    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Service request not found',
      });
    }

    res.status(200).json({
      success: true,
      data: request,
    });
  } catch (error) {
    console.error('Get request error:', error);
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});

module.exports = router;