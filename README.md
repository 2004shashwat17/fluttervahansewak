# Vahan Sewak - Vehicle Assistance App

A comprehensive Flutter mobile application for vehicle breakdown assistance in Delhi NCR, connecting customers with verified mechanics.

## Features

### For Customers
- Quick problem reporting with categories
- Photo/video upload for problem description
- Real-time mechanic location tracking
- Multiple payment options (Cash/Online)
- Rating and review system
- Emergency contact integration
- Multi-language support (English/Hindi)

### For Mechanics
- Real-time request notifications
- Location-based job matching
- Customer communication tools
- Earnings tracking
- Rating and review management
- Availability status management

## Tech Stack

### Frontend (Mobile App)
- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Provider
- **HTTP Client**: Dio
- **Maps**: Google Maps Flutter
- **Location**: Geolocator
- **Image Handling**: Image Picker
- **Local Storage**: SharedPreferences

### Backend (API)
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB
- **Authentication**: JWT
- **File Upload**: Multer
- **Security**: Helmet, CORS, Rate Limiting
- **Validation**: Mongoose Schema Validation

## Project Structure

```
vahan_sewak/
├── lib/                          # Flutter app source code
│   ├── screens/                  # UI screens
│   │   ├── customer/            # Customer-specific screens
│   │   └── mechanic/            # Mechanic-specific screens
│   ├── widgets/                 # Reusable UI components
│   ├── models/                  # Data models
│   ├── services/                # API and business logic
│   └── utils/                   # Utilities and helpers
├── backend/                     # Node.js API server
│   ├── models/                  # MongoDB models
│   ├── routes/                  # API routes
│   ├── controllers/             # Route handlers
│   ├── middleware/              # Authentication & validation
│   └── utils/                   # Helper functions
└── assets/                      # Images, fonts, etc.
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0+)
- Node.js (16+)
- MongoDB (local or cloud)
- Android Studio / VS Code
- Git

### Backend Setup

1. Navigate to backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create environment file:
   ```bash
   cp .env.example .env
   ```

4. Update `.env` with your configuration:
   ```env
   PORT=3000
   MONGODB_URI=mongodb://localhost:27017/vahan_sewak
   JWT_SECRET=your_jwt_secret_key
   GOOGLE_MAPS_API_KEY=your_google_maps_api_key
   ```

5. Start the server:
   ```bash
   npm run dev
   ```

### Frontend Setup

1. Navigate to project root:
   ```bash
   cd ..
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Update API base URL in `lib/services/api_service.dart`:
   ```dart
   static const String baseUrl = 'http://your-api-url:3000/api';
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/send-otp` - Send OTP
- `POST /api/auth/verify-phone` - Verify phone number

### Service Requests
- `POST /api/requests` - Create service request
- `GET /api/requests/customer/:id` - Get customer requests
- `GET /api/requests/nearby` - Get nearby requests (for mechanics)
- `PUT /api/requests/:id/accept` - Accept request
- `PUT /api/requests/:id/complete` - Complete request

### Mechanics
- `GET /api/mechanics/nearby` - Find nearby mechanics
- `PUT /api/mechanics/:id/location` - Update location
- `PUT /api/mechanics/:id/status` - Update online status
- `GET /api/mechanics/profile` - Get mechanic profile

### File Upload
- `POST /api/upload` - Upload images/videos

## Database Schema

### User Collection
```javascript
{
  name: String,
  phone: String (unique),
  email: String (unique),
  password: String (hashed),
  type: "customer" | "mechanic",
  profileImage: String,
  isVerified: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

### ServiceRequest Collection
```javascript
{
  customerId: ObjectId,
  mechanicId: ObjectId,
  problemType: String,
  description: String,
  vehicleNumber: String,
  customerLocation: {
    type: "Point",
    coordinates: [longitude, latitude],
    address: String
  },
  images: [String],
  paymentMethod: "cash" | "online",
  status: "pending" | "accepted" | "inProgress" | "completed" | "cancelled",
  estimatedCost: String,
  finalCost: Number,
  createdAt: Date,
  updatedAt: Date
}
```

### Mechanic Collection
```javascript
{
  userId: ObjectId,
  specialization: String,
  experienceYears: Number,
  rating: Number,
  totalJobs: Number,
  isVerified: Boolean,
  isOnline: Boolean,
  currentLocation: {
    type: "Point",
    coordinates: [longitude, latitude],
    address: String
  },
  pricePerHour: Number,
  reviews: [ReviewSchema],
  earnings: {
    thisMonth: Number,
    total: Number
  },
  createdAt: Date,
  updatedAt: Date
}
```

## Features to Implement

### Phase 1 (MVP)
- [x] User authentication
- [x] Problem reporting
- [x] Mechanic matching
- [x] Basic communication
- [x] Payment method selection

### Phase 2
- [ ] Real-time location tracking
- [ ] In-app messaging
- [ ] Push notifications
- [ ] Payment gateway integration
- [ ] Rating system

### Phase 3
- [ ] Advanced analytics
- [ ] Admin dashboard
- [ ] Multi-city support
- [ ] AI-powered problem diagnosis

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and queries, contact:
- Email: support@vahansewak.com
- Phone: +91-XXXX-XXXX
---

Made with ❤️ for Delhi NCR's vehicle owners and mechanics.
