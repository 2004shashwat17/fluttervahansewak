import 'package:flutter/material.dart';
import 'problem_description_screen.dart';

class ProblemSelectionScreen extends StatelessWidget {
  final List<ProblemType> problemTypes = [
    ProblemType(
      icon: Icons.settings,
      title: 'Engine Issues',
      description: 'Engine problems, overheating, strange noises',
    ),
    ProblemType(
      icon: Icons.info_outline,
      title: 'Brake Issues',
      description: 'Brake problems, grinding sounds',
    ),
    ProblemType(
      icon: Icons.directions_car,
      title: 'Fuel Issues',
      description: 'Out of fuel, fuel pump problems',
    ),
    ProblemType(
      icon: Icons.star_outline,
      title: 'Tire Puncture',
      description: 'Flat tire, tire replacement needed',
    ),
    ProblemType(
      icon: Icons.radio_button_unchecked,
      title: 'Lock/Unlock Issues',
      description: 'Key locked inside, door lock problems',
    ),
    ProblemType(
      icon: Icons.flash_on,
      title: 'Electrical Issues',
      description: 'Battery, lights, electrical problems',
    ),
    ProblemType(
      icon: Icons.build_circle,
      title: 'Engine Light',
      description: 'Check engine light, warning indicators',
    ),
    ProblemType(
      icon: Icons.local_gas_station,
      title: 'Tow Me',
      description: 'Vehicle towing service needed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'What\'s the problem?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select the issue you\'re experiencing:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                ),
                itemCount: problemTypes.length,
                itemBuilder: (context, index) {
                  final problem = problemTypes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProblemDescriptionScreen(
                            problemType: problem,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              problem.icon,
                              size: 40,
                              color: Color(0xFFFF6B35),
                            ),
                            SizedBox(height: 12),
                            Text(
                              problem.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              problem.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Other/Not Sure option
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProblemDescriptionScreen(
                      problemType: ProblemType(
                        icon: Icons.help_outline,
                        title: 'Other / Not Sure',
                        description: 'Describe your problem',
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6B35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Other / Not Sure',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProblemType {
  final IconData icon;
  final String title;
  final String description;

  ProblemType({
    required this.icon,
    required this.title,
    required this.description,
  });
}