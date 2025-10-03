import 'dart:convert';

class Mechanic {
  final String id;
  final String userId;
  final String specialization;
  final double rating;
  final int totalJobs;
  final List<String> certifications;
  final bool isVerified;
  final bool isOnline;
  final Location? currentLocation;
  final double pricePerHour;
  final String experienceYears;

  Mechanic({
    required this.id,
    required this.userId,
    required this.specialization,
    required this.rating,
    required this.totalJobs,
    required this.certifications,
    required this.isVerified,
    required this.isOnline,
    this.currentLocation,
    required this.pricePerHour,
    required this.experienceYears,
  });

  factory Mechanic.fromJson(Map<String, dynamic> json) {
    return Mechanic(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      specialization: json['specialization'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0,
      totalJobs: json['totalJobs'] ?? 0,
      certifications: List<String>.from(json['certifications'] ?? []),
      isVerified: json['isVerified'] ?? false,
      isOnline: json['isOnline'] ?? false,
      currentLocation: json['currentLocation'] != null 
          ? Location.fromJson(json['currentLocation']) 
          : null,
      pricePerHour: json['pricePerHour']?.toDouble() ?? 0.0,
      experienceYears: json['experienceYears'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'specialization': specialization,
      'rating': rating,
      'totalJobs': totalJobs,
      'certifications': certifications,
      'isVerified': isVerified,
      'isOnline': isOnline,
      'currentLocation': currentLocation?.toJson(),
      'pricePerHour': pricePerHour,
      'experienceYears': experienceYears,
    };
  }
}

class Location {
  final double latitude;
  final double longitude;
  final String address;

  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}