import 'package:flutter/material.dart';
import 'dart:async'; // Import for Timer

class UserManualScreen extends StatefulWidget {
  const UserManualScreen({super.key});

  @override
  _UserManualScreenState createState() => _UserManualScreenState();
}

class _UserManualScreenState extends State<UserManualScreen> {
  final PageController _pageController = PageController();
  bool _showSwipeIndicator = true; // Flag to show or hide the swipe indicator

  final List<String> _stepContent = [
    'Select "Scan Plant" to capture a photo or choose one from your gallery.',
    'Ensure the plant image is clear, well-lit, in focus, and not blurry.',
    'The system will identify the plant and display details, along with a "First Aid" button at the bottom.',
    'In the "First Aid" module, the appropriate treatment for the identified toxicity level will be shown. If immediate action is needed, click "Call Emergency".',
    'Clicking "Call Emergency" will automatically open your phone’s call app with the default emergency contact number pre-entered.',
  ];

  // List of GIFs corresponding to each step
  final List<String> _gifPaths = [
    'assets/gif/step1.gif',
    'assets/gif/step2.jpg',
    'assets/gif/step3.gif',
    'assets/gif/step4.gif',
    'assets/gif/step5.gif',
  ];

  @override
  void initState() {
    super.initState();
    // Hide the swipe indicator after 10 seconds
    Timer(const Duration(seconds: 10), () {
      setState(() {
        _showSwipeIndicator = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Manual',
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
        child: Stack(
          children: [
            // PageView for steps
            PageView.builder(
              controller: _pageController,
              itemCount: _stepContent.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Step Number with bold styling inside a colored box
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF4FAE50),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Text(
                          'Step ${index + 1}:',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10), // Space between step title and content

                      // Wrap the entire content in a SingleChildScrollView to avoid overflow
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFF4FAE50),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Step content text inside another box
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFF4FAE50),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    _stepContent[index],
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(height: 10), // Space between text box and GIF

                                // Step GIF inside the same parent box
                                Container(
                                  width: double.infinity,
                                  child: Image.asset(
                                    _gifPaths[index], // Use the appropriate GIF based on the step
                                    fit: BoxFit.contain, // Adjusts the GIF to fit within the given space
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            // Swipe indication at the bottom
            if (_showSwipeIndicator)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.swipe_left,
                        size: 40,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Swipe left or right to navigate',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
