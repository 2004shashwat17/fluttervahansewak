const mongoose = require('mongoose');

const MechanicSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true,
  },
  specialization: {
    type: String,
    required: true,
    enum: [
      'General Mechanic',
      'Engine Specialist', 
      'Brake Specialist',
      'Electrical Specialist',
      'Transmission Specialist',
      'Tire Specialist',
      'Towing Service',
    ],
  },
  experienceYears: {
    type: Number,
    required: true,
    min: [0, 'Experience cannot be negative'],
    max: [50, 'Experience cannot be more than 50 years'],
  },
  certifications: [{
    name: String,
    issuedBy: String,
    issuedDate: Date,
    expiryDate: Date,
    certificateUrl: String,
  }],
  rating: {
    type: Number,
    default: 0,
    min: 0,
    max: 5,
  },
  totalJobs: {
    type: Number,
    default: 0,
  },
  completedJobs: {
    type: Number,
    default: 0,
  },
  isVerified: {
    type: Boolean,
    default: false,
  },
  isOnline: {
    type: Boolean,
    default: false,
  },
  currentLocation: {
    type: {
      type: String,
      enum: ['Point'],
      default: 'Point',
    },
    coordinates: {
      type: [Number], // [longitude, latitude]
      default: [0, 0],
    },
    address: String,
    lastUpdated: {
      type: Date,
      default: Date.now,
    },
  },
  pricePerHour: {
    type: Number,
    required: true,
    min: [0, 'Price cannot be negative'],
  },
  availability: {
    monday: { start: String, end: String, available: Boolean },
    tuesday: { start: String, end: String, available: Boolean },
    wednesday: { start: String, end: String, available: Boolean },
    thursday: { start: String, end: String, available: Boolean },
    friday: { start: String, end: String, available: Boolean },
    saturday: { start: String, end: String, available: Boolean },
    sunday: { start: String, end: String, available: Boolean },
  },
  tools: [{
    name: String,
    category: String,
  }],
  serviceArea: {
    type: Number, // Radius in kilometers
    default: 10,
    max: [50, 'Service area cannot be more than 50km'],
  },
  reviews: [{
    customerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
    requestId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'ServiceRequest',
    },
    rating: {
      type: Number,
      required: true,
      min: 1,
      max: 5,
    },
    comment: String,
    createdAt: {
      type: Date,
      default: Date.now,
    },
  }],
  earnings: {
    thisMonth: {
      type: Number,
      default: 0,
    },
    total: {
      type: Number,
      default: 0,
    },
  },
}, {
  timestamps: true,
});

// Create geospatial index for location-based queries
MechanicSchema.index({ currentLocation: '2dsphere' });

// Index for efficient queries
MechanicSchema.index({ isOnline: 1, isVerified: 1 });
MechanicSchema.index({ specialization: 1, rating: -1 });

// Method to calculate average rating
MechanicSchema.methods.calculateAverageRating = function() {
  if (this.reviews.length === 0) return 0;
  
  const sum = this.reviews.reduce((acc, review) => acc + review.rating, 0);
  return (sum / this.reviews.length).toFixed(1);
};

// Method to check if mechanic is available at current time
MechanicSchema.methods.isAvailableNow = function() {
  if (!this.isOnline) return false;
  
  const now = new Date();
  const dayName = now.toLocaleLowerCase('en-US', { weekday: 'long' });
  const currentTime = now.getHours() * 100 + now.getMinutes();
  
  const daySchedule = this.availability[dayName];
  if (!daySchedule || !daySchedule.available) return false;
  
  const startTime = parseInt(daySchedule.start.replace(':', ''));
  const endTime = parseInt(daySchedule.end.replace(':', ''));
  
  return currentTime >= startTime && currentTime <= endTime;
};

// Update rating when a new review is added
MechanicSchema.pre('save', function(next) {
  if (this.isModified('reviews')) {
    this.rating = this.calculateAverageRating();
  }
  next();
});

module.exports = mongoose.model('Mechanic', MechanicSchema);