const mongoose = require('mongoose');

const ServiceRequestSchema = new mongoose.Schema({
  customerId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  mechanicId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    default: null,
  },
  problemType: {
    type: String,
    enum: [
      'engineIssues',
      'brakeIssues', 
      'fuelIssues',
      'tirePuncture',
      'lockIssues',
      'electricalIssues',
      'engineLight',
      'towMe',
      'other'
    ],
    required: true,
  },
  description: {
    type: String,
    required: [true, 'Problem description is required'],
    maxlength: [500, 'Description cannot be more than 500 characters'],
  },
  vehicleNumber: {
    type: String,
    uppercase: true,
    trim: true,
  },
  customerLocation: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point',
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      required: true,
    },
    address: {
      type: String,
      required: true,
    },
  },
  images: [{
    type: String, // URLs to uploaded images
  }],
  paymentMethod: {
    type: String,
    enum: ['cash', 'online'],
    required: true,
  },
  status: {
    type: String,
    enum: ['pending', 'accepted', 'inProgress', 'completed', 'cancelled'],
    default: 'pending',
  },
  estimatedCost: {
    type: String,
    default: null,
  },
  finalCost: {
    type: Number,
    default: null,
  },
  acceptedAt: {
    type: Date,
    default: null,
  },
  completedAt: {
    type: Date,
    default: null,
  },
  rating: {
    type: Number,
    min: 1,
    max: 5,
    default: null,
  },
  review: {
    type: String,
    maxlength: [200, 'Review cannot be more than 200 characters'],
  },
}, {
  timestamps: true,
});

// Create geospatial index for location-based queries
ServiceRequestSchema.index({ customerLocation: '2dsphere' });

// Index for efficient queries
ServiceRequestSchema.index({ customerId: 1, createdAt: -1 });
ServiceRequestSchema.index({ mechanicId: 1, createdAt: -1 });
ServiceRequestSchema.index({ status: 1, createdAt: -1 });

// Virtual for calculating elapsed time
ServiceRequestSchema.virtual('elapsedTime').get(function() {
  if (this.status === 'completed' && this.completedAt) {
    return this.completedAt - this.createdAt;
  }
  return Date.now() - this.createdAt;
});

// Method to calculate distance from a point
ServiceRequestSchema.methods.distanceFrom = function(longitude, latitude) {
  const R = 6371; // Earth's radius in kilometers
  const dLat = (latitude - this.customerLocation.coordinates[1]) * Math.PI / 180;
  const dLon = (longitude - this.customerLocation.coordinates[0]) * Math.PI / 180;
  const a = 
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(this.customerLocation.coordinates[1] * Math.PI / 180) * 
    Math.cos(latitude * Math.PI / 180) * 
    Math.sin(dLon/2) * Math.sin(dLon/2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return R * c;
};

module.exports = mongoose.model('ServiceRequest', ServiceRequestSchema);