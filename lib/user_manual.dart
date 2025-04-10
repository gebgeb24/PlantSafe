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
      'color': const Color(0xFF26A69A),
    },
    {
      'title': 'Ensure Image Quality',
      'description': '', // Empty description for step 2
      'image': 'assets/gif/step2.jpg',
      'icon': Icons.photo_camera,
      'hasBullets': false,
      'color': const Color(0xFF66BB6A),
    },
    {
      'title': 'View Plant Details',
      'description': 'The app will identify the plant and show:\n• Toxicity level\n• Scientific information\n• First Aid button',
      'image': 'assets/gif/step3.gif',
      'icon': Icons.eco,
      'hasBullets': true,
      'color': const Color(0xFF42A5F5),
    },
    {
      'title': 'First Aid Guidance',
      'description': 'The "First Aid" section provides:\n• Specific treatment steps\n• Emergency actions\n• Call emergency option',
      'image': 'assets/gif/step4.gif',
      'icon': Icons.medical_services,
      'hasBullets': true,
      'color': const Color(0xFFEF5350),
    },
    {
      'title': 'Emergency Calling',
      'description': 'In urgent cases:\n• Tap "Call Emergency"\n• App will dial local emergency number\n• Follow operator instructions',
      'image': 'assets/gif/step5.png',
      'icon': Icons.emergency,
      'hasBullets': true,
      'color': const Color(0xFFFF7043),
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
          fontSize: 17,
          height: 1.6,
          color: Color(0xFF424242),
          letterSpacing: 0.3,
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
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF424242),
                  ),
                ),
                Expanded(
                  child: Text(
                    line.substring(2),
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.6,
                      color: Color(0xFF424242),
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            line,
            style: const TextStyle(
              fontSize: 17,
              height: 1.6,
              color: Color(0xFF424242),
              letterSpacing: 0.3,
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'User Manual',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 12.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF43A047),
              Color(0xFF1B5E20),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Page View
              PageView.builder(
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
                  final isStep5 = index == 4;
                  final stepColor = step['color'] as Color;

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      key: ValueKey<int>(index),
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                      child: Column(
                        children: [
                          // Step indicator
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            height: 5,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: _steps.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                return Container(
                                  width: (size.width - 80) / _steps.length,
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    color: i <= _currentPage
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Main Card
                          Expanded(
                            child: Card(
                              elevation: 12,
                              shadowColor: Colors.black.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Column(
                                  children: [
                                    // Header with Title and Step
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                                      child: Row(
                                        children: [
                                          // Step Number
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              gradient: LinearGradient(
                                                colors: [
                                                  stepColor.withOpacity(0.8),
                                                  stepColor,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: stepColor.withOpacity(0.4),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),

                                          // Title and Icon
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  step['title'],
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w700,
                                                    color: stepColor,
                                                    height: 1.2,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      step['icon'] as IconData? ?? Icons.help,
                                                      size: 18,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      'Step ${index + 1} of ${_steps.length}',
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Content
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                        child: Column(
                                          children: [
                                            // Image
                                            Container(
                                              height: isStep2 ? size.height * 0.45 : isStep5 ? size.height * 0.25 : size.height * 0.3,
                                              margin: const EdgeInsets.symmetric(vertical: 16),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.15),
                                                    blurRadius: 12,
                                                    offset: const Offset(0, 5),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Image.asset(
                                                  step['image']!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) =>
                                                      Container(
                                                        color: Colors.grey[200],
                                                        child: const Center(
                                                          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),

                                            // Description
                                            if (!isStep2 && step['description'].isNotEmpty)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                                child: _buildDescriptionText(
                                                  step['description'],
                                                  step['hasBullets'],
                                                ),
                                              ),

                                            const SizedBox(height: 24),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.swipe,
                            size: 24,
                            color: Color(0xFF43A047),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Swipe to continue',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}