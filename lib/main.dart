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
        Image.asset('assets/images/logo.png', width: 450, height: 450),
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
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Image.asset(
                  'assets/images/logo.png',
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
                  color: Color(0xFF309c39)
                  ,
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

              // 2x2 Grid of Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: GridView.builder(
                  shrinkWrap: true, // To make it work inside a Column
                  physics: NeverScrollableScrollPhysics(), // Disable scroll
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return _buildButton(
                          context,
                          'Scan',
                              () {
                            _showScanOptionsDialog(context);
                          },
                          screenWidth / 2 - 32,
                          'assets/images/mainScan.png',
                        );
                      case 1:
                        return _buildButton(
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
                          screenWidth / 2 - 32,
                          'assets/images/mainLibrary.png',
                        );
                      case 2:
                        return _buildButton(
                          context,
                          'Manual',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserManualScreen()),
                            ).then((_) {
                              _showTriviaPopup();
                            });
                          },
                          screenWidth / 2 - 32,
                          'assets/images/mainManual.png',
                        );
                      case 3:
                        return _buildButton(
                          context,
                          'References',
                              () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ReferenceScreen()),
                            );
                          },
                          screenWidth / 2 - 32,
                          'assets/images/mainReference.png',
                        );
                      default:
                        return Container();
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          // Grass image at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/grass.png',
              width: screenWidth,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, VoidCallback onPressed,
      double width, String iconPath) {
    const double iconSize = 70; // Adjusted icon size
    const double textHeight = 30; // Estimated height for the text line
    const double padding = 20; // Padding around the icon and text
    const double iconTextSpacing = 15; // Additional space between the icon and text

    return SizedBox(
      width: width,
      height: iconSize + textHeight + padding + iconTextSpacing, // Increase height for spacing
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF309c39)
          ,
          // Set button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0), // Rounded corners
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: iconSize, // Adjust icon size here
              height: iconSize,
              color: const Color(0xFFe9ffc8), // Set icon color
            ),
            const SizedBox(height: iconTextSpacing), // Adds space between the icon and the text
            Text(
              text,
              style: const TextStyle(
                fontSize: 18, // Adjusted font size
                fontWeight: FontWeight.bold, // Bold text
                color: Color(0xFFe9ffc8), // Set text color to Color(0xFFe9ffc8)
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
    final random = Random();
    final trivia = triviaList[random.nextInt(triviaList.length)];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: SingleChildScrollView( // Make the entire dialog scrollable
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensure it shrinks to fit content
                children: [
                  // Title Box - Green box
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4FAE50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: double.infinity, // Make the width match the image
                    child: const Text(
                      'Did you know?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10), // Spacing between title and image
                  // Trivia Image
                  GestureDetector(
                    onTap: () {
                      _showFullScreenImage(context, trivia.imageUrl);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        trivia.imageUrl,
                        width: double.infinity, // Image will take up available width
                        height: 400, // Set height to prevent large gaps
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Spacing between image and title
                  // Trivia Title Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF00481c), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        trivia.title,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00481c),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Spacing between title and description
                  // Trivia Description Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF00481c), width: 2),
                    ),
                    child: Text(
                      trivia.description,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to show full-screen zoomable image
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Zoomable Image
              InteractiveViewer(
                minScale: 1.0,
                maxScale: 5.0,
                child: Center(
                  child: Image.asset(imageUrl, fit: BoxFit.contain),
                ),
              ),
              // Close Button
              Positioned(
                top: 40,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
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