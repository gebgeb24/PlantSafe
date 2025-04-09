import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class UserManualScreen extends StatefulWidget {
  const UserManualScreen({super.key});

  @override
  _UserManualScreenState createState() => _UserManualScreenState();
}

class _UserManualScreenState extends State<UserManualScreen> {
  final PageController _pageController = PageController();
  bool _showSwipeIndicator = true;
  int _currentPage = 0;
  Timer? _indicatorTimer;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Capture or Select Plant',
      'description': 'Use the "Scan Plant" feature to either take a new photo or choose one from your gallery.',
      'image': 'assets/gif/step1.gif',
      'icon': Icons.camera_alt,
      'hasBullets': false,
    },
    {
      'title': 'Ensure Image Quality',
      'description': '', // Empty description for step 2
      'image': 'assets/gif/step2.jpg',
      'icon': Icons.photo_camera,
      'hasBullets': false,
    },
    {
      'title': 'View Plant Details',
      'description': 'The app will identify the plant and show:\n• Toxicity level\n• Scientific information\n• First Aid button',
      'image': 'assets/gif/step3.gif',
      'icon': Icons.eco,
      'hasBullets': true,
    },
    {
      'title': 'First Aid Guidance',
      'description': 'The "First Aid" section provides:\n• Specific treatment steps\n• Emergency actions\n• Call emergency option',
      'image': 'assets/gif/step4.gif',
      'icon': Icons.medical_services,
      'hasBullets': true,
    },
    {
      'title': 'Emergency Calling',
      'description': 'In urgent cases:\n• Tap "Call Emergency"\n• App will dial local emergency number\n• Follow operator instructions',
      'image': 'assets/gif/step5.png',
      'icon': Icons.emergency,
      'hasBullets': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _indicatorTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() => _showSwipeIndicator = false);
      }
    });
  }

  @override
  void dispose() {
    _indicatorTimer?.cancel();
    _pageController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  Widget _buildDescriptionText(String text, bool hasBullets) {
    if (!hasBullets) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      );
    }

    final lines = text.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        if (line.startsWith('•')) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 18)),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            line,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Manual',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF4FAE50),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE9FFC8),
              Color(0xFFD1F0A8),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Progress Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _steps.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF4FAE50)
                              : Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),

                // Page View
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _steps.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      if (_indicatorTimer != null) {
                        _indicatorTimer!.cancel();
                      }
                      _indicatorTimer = Timer(const Duration(seconds: 8), () {
                        if (mounted) {
                          setState(() => _showSwipeIndicator = false);
                        }
                      });
                    },
                    itemBuilder: (context, index) {
                      final step = _steps[index];
                      final isStep2 = index == 1;
                      final isStep5 = index == 4;// Special case for step 2


                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Padding(
                          key: ValueKey<int>(index),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.2),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Header with Icon
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF4FAE50).withOpacity(0.1),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4FAE50),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green.withOpacity(0.3),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            step['icon'] as IconData? ?? Icons.help,
                                            size: 36,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Step ${index + 1}: ${step['title']}',
                                          style: theme.textTheme.headlineSmall?.copyWith(
                                            color: const Color(0xFF2E7D32),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Content
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            if (!isStep2 && step['description'].isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 20),
                                                child: _buildDescriptionText(
                                                  step['description'],
                                                  step['hasBullets'],
                                                ),
                                              ),
                                            Container(
                                              height: isStep2 ? size.height * 0.55 : isStep5 ? size.height * 0.3 : size.height * 0.4,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.1),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: Image.asset(
                                                  step['image']!,
                                                  fit: BoxFit.contain,
                                                  errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.image_not_supported, size: 10),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Footer
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      '${index + 1}/${_steps.length}',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Swipe Indicator
            if (_showSwipeIndicator)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _showSwipeIndicator ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.swipe,
                        size: 40,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Swipe to continue',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
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