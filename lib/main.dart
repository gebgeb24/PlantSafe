import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant/reference.dart';
import 'dart:async';
import 'dart:math';

// Import the new screens
import 'library.dart';
import 'user_manual.dart';
import 'scanplant.dart'; // Import ScanPlantScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
            Image.asset('assets/images/whitelogo.jpg', width: 500, height: 500),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Trivia> triviaList = const [
    Trivia(
      title: 'Buttercup',
      description:
          'Throughout history, buttercups have been associated with various meanings such as happiness, wealth, prosperity, and even childhood nostalgia. They are often regarded as a symbol of positivity and joy.',
      imageUrl: 'assets/images/trivia/buttercup.jpg',
    ),
    Trivia(
      title: 'Clematis',
      description:
          'The nectar-rich flowers of clematis are a magnet for butterflies and bees. By planting clematis in your garden, you can create a welcoming habitat for these important pollinators, helping to support biodiversity and the overall health of your ecosystem.',
      imageUrl: 'assets/images/trivia/clematis.jpg',
    ),
    Trivia(
      title: 'Copperleaf',
      description:
          'The Acalypha wilkesiana, commonly known as Copperleaf, is a stunning plant with vibrant red, bronze, and green foliage that can beautify any garden or indoor space. However, its sap can cause skin irritation or dermatitis, so it is essential to handle it with care.',
      imageUrl: 'assets/images/trivia/copperleaf.jpg',
    ),
    Trivia(
      title: 'Crinum Lily',
      description:
          'Crinum Lily has a long lifespan, with some varieties living for up to 50 years or more. This longevity ensures years of enjoyment for gardeners who choose to cultivate this striking plant.',
      imageUrl: 'assets/images/trivia/crinum lily.jpg',
    ),
    Trivia(
      title: 'Elephant\'s Ear',
      description:
          'Elephant\'s Ear is sometimes grown as a crop in Southeast Asia and Hawaii. When cooked properly, the tubers can be turned into potato-like food, though raw plants can be toxic to children or pets.',
      imageUrl: 'assets/images/trivia/elephant ear.JPG',
    ),
    Trivia(
      title: 'Fishtail Palm',
      description:
          'The fruit starts out green and ends up black/purple when it ripens. The seed is edible, but the soft part on the outside (pericarp) contains calcium oxalates and is inedible.',
      imageUrl: 'assets/images/trivia/fishtail palm.jpg',
    ),
    Trivia(
      title: 'Hydrangea',
      description:
          'Hydrangeas have symbolic meanings that vary by culture; in Japan, they symbolize apology and gratitude, while in the United States, they often represent heartfelt emotion and are popular Mother\'s Day gifts.',
      imageUrl: 'assets/images/trivia/hydrangea.jpg',
    ),
    Trivia(
      title: 'Iris',
      description:
          'Some species of iris flowers are known for their sweet fragrance, which has made them popular in the perfume industry.',
      imageUrl: 'assets/images/trivia/iris.JPG',
    ),
    Trivia(
      title: 'Pothos',
      description:
          'Research has shown that pothos plants have the ability to remove toxins like formaldehyde, benzene, and xylene from the air, making it a great addition to any home or office.',
      imageUrl: 'assets/images/trivia/pothos.JPG',
    ),
    Trivia(
      title: 'Stinging Nettles',
      description:
          'During the Second World War, children were encouraged to collect them so that they could be used to produce a dark green dye for camouflage.',
      imageUrl: 'assets/images/trivia/stinging nettle.JPG',
    ),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showTriviaPopup(); // Show trivia when the dashboard is displayed
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFe9ffc8),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Logo
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Image.asset(
              'assets/images/logo.jpg',
              width: screenWidth * 0.9,
            ),
          ),
          // Title
          const Text(
            'Your Go-to Toxic\nPlant Guide',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFFe2a52a),
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Color(0x80000000),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Scan Plant Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: _buildButton(
              context,
              'Scan Plant',
              () {
                _showScanOptionsDialog(context);
              },
              screenWidth - 64,
              'assets/images/scan.png',
            ),
          ),
          const SizedBox(height: 15),

          // Row with Library and User Manual buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildButton(
                  context,
                  'Library',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LibraryScreen()),
                    ).then((_) {
                      _showTriviaPopup();
                    });
                  },
                  (screenWidth - 80) / 2,
                  'assets/images/leaf.png',
                ),
                _buildButton(
                  context,
                  'User Manual',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserManualScreen()),
                    ).then((_) {
                      _showTriviaPopup();
                    });
                  },
                  (screenWidth - 80) / 2,
                  'assets/images/manual.png',
                ),
              ],
            ),
          ),

          // Spacer to push the References button to the bottom
          const SizedBox(height: 20),

          // References Button (Different Style)
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReferenceScreen()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF4fae50), // No background color
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                      color: Color(0xFF08411c), width: 5), // Black border
                ),
              ),
              child: const Text(
                'References',
                style: TextStyle(
                  fontSize: 16, // Adjusted font size
                  fontWeight: FontWeight.bold, // Bold text
                  color: Color(0xFF05421c), // Black text
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed,
      double width, String iconPath) {
    const double iconSize = 100; // Adjusted icon size
    const double textHeight = 30; // Estimated height for the text line
    const double padding = 20; // Padding around the icon and text

    return SizedBox(
      width: width,
      height: iconSize + textHeight + padding,
      // Dynamically set height based on icon and text
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4fae50),
          // Set button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
            side: const BorderSide(
              color: Color(0xFF08411c), // Border color
              width: 5, // Border width
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: iconSize, // Adjust icon size here
              height: iconSize,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16, // Adjusted font size
                fontWeight: FontWeight.bold, // Bold text
                color: Color(0xFF05421c), // Button text color #05421c
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScanOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  showInstructionDialog(
                      context); // Show the instruction popup first
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4fae53),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Take Photo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScanPlantScreen(
                            gallery:
                                true)), // Navigate to ScanPlantScreen with gallery option
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4fae53),
                  // Button background color
                  minimumSize: const Size(
                      double.infinity, 50), // Same width for all buttons
                ),
                child: const Text(
                  'Select from Gallery',
                  style: TextStyle(
                    color: Colors.white, // Button text color
                    fontSize: 20, // Font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4fae53),
                  // Button background color
                  minimumSize: const Size(
                      double.infinity, 50), // Same width for all buttons
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.white, // Button text color
                    fontSize: 20, // Font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTriviaPopup() {
    // Select a random trivia from the list
    final random = Random();
    final trivia = triviaList[random.nextInt(triviaList.length)];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 10,
              // Add shadow to the trivia box
              contentPadding: EdgeInsets.zero,
              // Remove default padding
              content: Container(
                width: 400,
                // Set a fixed width for the popup
                padding: const EdgeInsets.all(16),
                // Padding around content inside popup
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // "Did you know?" box
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // Set border radius to 5px
                        color: Color(
                            0xFF4FAE50), // Background color set to #4fae50
                      ),
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width *
                          0.95, // Set width to 95%
                      child: const Center(
                        // Center the text
                        child: Text(
                          'Did you know?',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold, // Bolder font
                            color: Colors.white, // Text color
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Add some spacing
                    // Trivia image
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF00481c),
                            width: 3), // Border color and width
                        borderRadius:
                            BorderRadius.circular(5), // Rounded corners
                      ),
                      width: MediaQuery.of(context).size.width *
                          0.95, // Set width to 95%
                      height: 300, // Set image height
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2.5),
                        child: Image.asset(
                          trivia.imageUrl,
                          fit: BoxFit.cover, // Fit the image within the box
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Add some spacing
                    // Title box
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF00481c),
                            width: 3), // Border color and width
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white, // Background color
                      ),
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width *
                          0.95, // Set width to 95%
                      child: Center(
                        // Center the text
                        child: Text(
                          trivia.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold, // Bolder font
                            color: Color(0xFF00481c), // Text color set to white
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Add some spacing

                    // Description box
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF00481c), width: 3),
                        // Border color and width
                        borderRadius: BorderRadius.circular(5),
                        // Rounded corners
                        color: Color(
                            0xFFDCDCDC), // Background color changed to #dcdcdc
                      ),
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width *
                          0.95, // Set width to 95%
                      child: Text(
                        trivia.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Text color
                        ),
                        textAlign: TextAlign.justify, // Justify text
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Circular Close Button exactly on the top right edge of the AlertDialog box
            Positioned(
              top: 60,
              // Move upwards to overlap slightly on the AlertDialog's top edge
              right: 20,
              // Move leftwards to overlap slightly on the right edge
              child: CircleAvatar(
                backgroundColor: Colors.grey, // Red background for the button
                radius: 20, // Circle size
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white, // White X icon
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showInstructionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Follow these steps for better plant identification:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              _buildInstructionRow('assets/images/sun.png',
                  'Ensure good lighting (natural light is best).'),
              _buildInstructionRow('assets/images/mobile.png',
                  'Hold the camera steady to avoid blur.'),
              _buildInstructionRow('assets/images/leaf1.png',
                  'Avoid capturing multiple plants in one frame.'),
              _buildInstructionRow('assets/images/reach.png',
                  'Remove obstructions like hands or shadows.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Close dialog and return to selection screen
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18), // Optional: Highlight Cancel in red
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ScanPlantScreen(camera: true)),
                ); // Open camera
              },
              child: const Text(
                'OK',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 18), // Set text color to green
              ),
            ),
          ],
        );
      },
    );
  }

// Helper function to build instruction rows with icons
  Widget _buildInstructionRow(String imagePath, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      // Adds spacing between rows
      child: Row(
        children: [
          Image.asset(imagePath, width: 28, height: 28), // Display the icon
          const SizedBox(width: 10), // Space between icon and text
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// Create a class for trivia items
class Trivia {
  final String title;
  final String description;
  final String imageUrl;

  const Trivia(
      {required this.title, required this.description, required this.imageUrl});
}
