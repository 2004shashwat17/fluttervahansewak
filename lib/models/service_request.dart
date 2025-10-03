import 'dart:convert';

class ServiceRequest {
  final String id;
  final String customerId;
  final String? mechanicId;
  final ProblemType problemType;
  final String description;
  final String? vehicleNumber;
  final Location customerLocation;
  final List<String> images;
  final PaymentMethod paymentMethod;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final String? estimatedCost;
  final String? finalCost;

  ServiceRequest({
    required this.id,
    required this.customerId,
    this.mechanicId,
    required this.problemType,
    required this.description,
    this.vehicleNumber,
    required this.customerLocation,
    required this.images,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.completedAt,
    this.estimatedCost,
    this.finalCost,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) {
    return ServiceRequest(
      id: json['_id'] ?? '',
      customerId: json['customerId'] ?? '',
      mechanicId: json['mechanicId'],
      problemType: ProblemType.values.firstWhere(
        (e) => e.toString().split('.').last == json['problemType'],
        orElse: () => ProblemType.other,
      ),
      description: json['description'] ?? '',
      vehicleNumber: json['vehicleNumber'],
      customerLocation: Location.fromJson(json['customerLocation']),
      images: List<String>.from(json['images'] ?? []),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString().split('.').last == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      status: RequestStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => RequestStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      estimatedCost: json['estimatedCost'],
      finalCost: json['finalCost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'customerId': customerId,
      'mechanicId': mechanicId,
      'problemType': problemType.toString().split('.').last,
      'description': description,
      'vehicleNumber': vehicleNumber,
      'customerLocation': customerLocation.toJson(),
      'images': images,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'estimatedCost': estimatedCost,
      'finalCost': finalCost,
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

enum ProblemType {
  engineIssues,
  brakeIssues,
  fuelIssues,
  tirePuncture,
  lockIssues,
  electricalIssues,
  engineLight,
  towMe,
  other,
}

enum PaymentMethod {
  cash,
  online,
}

enum RequestStatus {
  pending,
  accepted,
  inProgress,
  completed,
  cancelled,
}