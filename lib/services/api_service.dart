import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/service_request.dart';
import '../models/mechanic.dart';
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  final AuthService _authService;

  ApiService(this._authService);

  Map<String, String> get _headers => _authService.headers;

  // Service Request APIs
  Future<bool> createServiceRequest(ServiceRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/requests'),
        headers: _headers,
        body: json.encode(request.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Create service request error: $e');
      return false;
    }
  }

  Future<List<ServiceRequest>> getCustomerRequests(String customerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/requests/customer/$customerId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ServiceRequest.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Get customer requests error: $e');
      return [];
    }
  }

  Future<List<ServiceRequest>> getNearbyRequests(double lat, double lng, double radiusKm) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/requests/nearby?lat=$lat&lng=$lng&radius=$radiusKm'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ServiceRequest.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Get nearby requests error: $e');
      return [];
    }
  }

  Future<bool> acceptRequest(String requestId, String mechanicId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/requests/$requestId/accept'),
        headers: _headers,
        body: json.encode({'mechanicId': mechanicId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Accept request error: $e');
      return false;
    }
  }

  Future<bool> completeRequest(String requestId, String finalCost) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/requests/$requestId/complete'),
        headers: _headers,
        body: json.encode({'finalCost': finalCost}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Complete request error: $e');
      return false;
    }
  }

  // Mechanic APIs
  Future<List<Mechanic>> getNearbyMechanics(double lat, double lng, double radiusKm) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mechanics/nearby?lat=$lat&lng=$lng&radius=$radiusKm'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Mechanic.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Get nearby mechanics error: $e');
      return [];
    }
  }

  Future<bool> updateMechanicLocation(String mechanicId, double lat, double lng) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/mechanics/$mechanicId/location'),
        headers: _headers,
        body: json.encode({
          'latitude': lat,
          'longitude': lng,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update mechanic location error: $e');
      return false;
    }
  }

  Future<bool> updateMechanicStatus(String mechanicId, bool isOnline) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/mechanics/$mechanicId/status'),
        headers: _headers,
        body: json.encode({'isOnline': isOnline}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update mechanic status error: $e');
      return false;
    }
  }

  // File Upload API
  Future<String?> uploadImage(String filePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload'),
      );
      
      request.headers.addAll(_headers);
      request.files.add(await http.MultipartFile.fromPath('image', filePath));

      final response = await request.send();
      
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final result = json.decode(String.fromCharCodes(responseData));
        return result['url'];
      }
      return null;
    } catch (e) {
      print('Upload image error: $e');
      return null;
    }
  }
}