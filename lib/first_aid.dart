import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class FirstAid extends StatelessWidget {
  final String predictedClass;
  final String toxicityIndex;

  const FirstAid({
    super.key,
    required this.predictedClass,
    required this.toxicityIndex,
  });

  // Define an array of toxicity information
  static const List<Map<String, dynamic>> toxicityInfo = [
    {
      'level': 'Major',
      'description': 'These plants may cause serious illness or death.',
      'symptoms': 'Severe abdominal pain, nausea, vomiting, dizziness, breathing difficulties, organ failure.',
      'firstAidGuide': [
        'Seek Emergency Help Immediately.',
        'Do not induce vomiting unless advised by a healthcare provider.',
        'Keep the person calm and still while awaiting medical assistance.'
      ],
      'img': 'assets/images/firstaidImg/major.JPG'
    },
    {
      'level': 'Minor',
      'description': 'Ingestion of these plants may cause minor illnesses such as vomiting or diarrhea.',
      'symptoms': 'Nausea, mild abdominal pain, vomiting, and diarrhea.',
      'firstAidGuide': [
        'Drink water or milk if your mouth or throat feel irritated or burned.',
        'Rinse your skin as soon as possible if the poison got to it.',
        'Rinse your eyes with saline drops if it got in them.'
      ],
      'img': 'assets/images/firstaidImg/minor.JPG'
    },
    {
      'level': 'Oxalates',
      'description': 'The juice or sap of these plants contains needle-shaped oxalate crystals that can irritate skin, mouth, tongue, and throat.',
      'symptoms': 'Pain, swelling, irritation in the mouth and throat, difficulty swallowing or breathing, burning pain, and stomach upset.',
      'firstAidGuide': [
        'Remove all plant matter from the mouth, eyes, and skin to decontaminate them.',
        'Use a lot of water to irrigate exposed skin and eyes.',
        'For pain, analgesics might be necessary. '
      ],
      'img': 'assets/images/firstaidImg/oxalates.JPG'
    },
    {
      'level': 'Dermatitis',
      'description': 'The juice, sap, or thorns of these plants may cause a skin rash or irritation.',
      'symptoms': 'Skin irritation, redness, itching, rash, or blistering on contact.',
      'firstAidGuide': [
        'Wash the affected area with soap and water as soon as possible.',
        'Apply a cool compress to soothe irritation and reduce inflammation.',
        'Avoid scratching to prevent further irritation or potential infection.'
      ],
      'img': 'assets/images/firstaidImg/derma.JPG'
    },
  ];

  // Method to launch the dialer with the specified number
  Future<void> _callEmergency() async {
    var status = await Permission.phone.status;

    if (!status.isGranted) {
      status = await Permission.phone.request();
    }

    if (status.isGranted) {
      final Uri phoneUri = Uri(scheme: 'tel', path: '09263438634');
      if (await canLaunch(phoneUri.toString())) {
        await launch(phoneUri.toString());
      } else {
        throw 'Could not launch $phoneUri';
      }
    } else {
      print('Permission to make calls denied.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Split toxicityIndex into words (toxicity levels)
    final List<String> toxicityLevels = toxicityIndex.split(RegExp(r'\s+'));

    // Get details for each matched toxicity level
    final List<Map<String, dynamic>> matchedToxicityDetails = toxicityLevels
        .map((level) {
      // Find matching toxicity level in toxicityInfo
      return toxicityInfo.firstWhere(
            (info) => info['level'] == level,
        orElse: () => <String, dynamic>{}, // Return empty map if no match
      );
    })
        .where((details) => details.isNotEmpty) // Remove empty maps
        .toList();

    // Now matchedToxicityDetails contains only valid matched toxicity levels
    // Your code to display matched details


  return Scaffold(
      appBar: AppBar(
        title: const Text(
          'First Aid Guide',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF369E40),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFFE9FFC8),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Padding for the body content
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // First aid guide section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xFF4FAE50),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                    children: [
                      Center( // Center the first text widget
                        child: Text(
                          'First aid guide for: $predictedClass',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4FAE50),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center( // Center the second text widget
                        child: Text(
                          'Toxicity Index: $toxicityIndex',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4FAE50),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 10),
                // TOXIC section
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: const Color(0xFF980000),
                      width: 3,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'TOXIC',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                // Loop through each matched toxicity level and display its details
                for (var details in matchedToxicityDetails) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: const Color(0xFF4FAE50),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Toxicity Level:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4FAE50),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      '${details['level'] ?? 'Unknown'}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            details['description'] ?? 'No information available.',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Symptoms:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${details['symptoms'] ?? 'No information available.'}',
                            style: const TextStyle(fontSize: 18),
                          ),

                          // Add the Image.asset widget here
                          Image.asset(
                            details['img'] ?? 'assets/images/firstaidImg/major.JPG', // Ensure the path is correct
                            width: double.infinity, // Adjust width as needed
                            height: 200, // Adjust height as needed
                            fit: BoxFit.contain, // Ensures the image fits well
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E2E2),
                              border: Border.all(color: const Color(0xFF4FAE50), width: 3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'First Aid Guide:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ...?details['firstAidGuide']?.asMap().entries.map<Widget>((entry) {
                                  int index = entry.key + 1;
                                  String step = entry.value;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      '$index. $step',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Emergency button at the bottom

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFF980000),
                      width: 5,
                    ),
                  ),
                  child: TextButton(
                    onPressed: _callEmergency,
                    child: const Text(
                      'Call Emergency',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }




}
