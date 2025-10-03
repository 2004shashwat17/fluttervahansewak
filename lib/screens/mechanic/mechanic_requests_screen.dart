import 'package:flutter/material.dart';
import 'request_detail_screen.dart';

class MechanicRequestsScreen extends StatefulWidget {
  @override
  _MechanicRequestsScreenState createState() => _MechanicRequestsScreenState();
}

class _MechanicRequestsScreenState extends State<MechanicRequestsScreen> {
  final List<CustomerRequest> requests = [
    CustomerRequest(
      id: '1',
      customerName: 'Rajesh Kumar',
      problemType: 'Engine Issues',
      description: 'Car making strange noises, engine overheating',
      vehicleNumber: 'DL01AA1234',
      distance: '0.8 km',
      timeAgo: '2 min ago',
      estimatedPayment: '₹500-800',
      isUrgent: true,
    ),
    CustomerRequest(
      id: '2',
      customerName: 'Priya Sharma',
      problemType: 'Tire Puncture',
      description: 'Front left tire punctured, need replacement',
      vehicleNumber: 'DL05BB5678',
      distance: '1.2 km',
      timeAgo: '5 min ago',
      estimatedPayment: '₹300-500',
      isUrgent: false,
    ),
    CustomerRequest(
      id: '3',
      customerName: 'Amit Singh',
      problemType: 'Battery Dead',
      description: 'Car won\'t start, battery seems dead',
      vehicleNumber: 'DL03CC9012',
      distance: '2.1 km',
      timeAgo: '8 min ago',
      estimatedPayment: '₹200-400',
      isUrgent: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Customer Requests',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              // Refresh requests
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Stats
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _buildHeaderStat(
                    '23',
                    'Active Requests',
                    Icons.notifications_active,
                    Colors.red,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildHeaderStat(
                    '0.8 km',
                    'Nearest Request',
                    Icons.location_on,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          
          // Requests List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestDetailScreen(request: request),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: request.isUrgent
                          ? Border.all(color: Colors.red, width: 2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFFFF6B35).withOpacity(0.1),
                              child: Text(
                                request.customerName[0].toUpperCase(),
                                style: TextStyle(
                                  color: Color(0xFFFF6B35),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        request.customerName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (request.isUrgent) ...[
                                        SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'URGENT',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    request.vehicleNumber,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  request.distance,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[600],
                                  ),
                                ),
                                Text(
                                  request.timeAgo,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        
                        // Problem Type
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF6B35).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            request.problemType,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFFF6B35),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        
                        // Description
                        Text(
                          request.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 12),
                        
                        // Bottom Row
                        Row(
                          children: [
                            Icon(
                              Icons.currency_rupee,
                              size: 16,
                              color: Colors.green[600],
                            ),
                            Text(
                              request.estimatedPayment,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[600],
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequestDetailScreen(request: request),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFFFF6B35),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomerRequest {
  final String id;
  final String customerName;
  final String problemType;
  final String description;
  final String vehicleNumber;
  final String distance;
  final String timeAgo;
  final String estimatedPayment;
  final bool isUrgent;

  CustomerRequest({
    required this.id,
    required this.customerName,
    required this.problemType,
    required this.description,
    required this.vehicleNumber,
    required this.distance,
    required this.timeAgo,
    required this.estimatedPayment,
    required this.isUrgent,
  });
}