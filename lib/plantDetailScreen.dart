import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter_map/flutter_map.dart'; // Import the flutter_map package
import 'package:latlong2/latlong.dart'; // Import the latlong2 package
import 'package:location/location.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';


class plantDetailScreen extends StatefulWidget {
  final Map<String, dynamic> plant;

  const plantDetailScreen({Key? key, required this.plant}) : super(key: key);

  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Zoomable and Pannable Image
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close when tapped
              },
              child: Hero(
                tag: imageUrl,
                child: InteractiveViewer(
                  minScale: 1.0, // Default scale
                  maxScale: 5.0, // Allows zooming up to 5x
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          // Close Button (Top Right)
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(0.7),
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class PlantDetailScreen extends StatefulWidget {
  @override
  _PlantDetailScreenState createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<plantDetailScreen> {
  int _currentIndex = 0;
  LocationData? _userLocation;

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _getUserLocation();

    initConnectivity();



    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    super.initState();
    _prepareText();



    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
        _isPaused = false;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
        _isPaused = false;
      });
    });

    _flutterTts.setCancelHandler(() {
      setState(() {
        _isSpeaking = false;
        _isPaused = false;
      });

    });
  }

  final FlutterTts _flutterTts = FlutterTts(); // Initialize FlutterTts

  bool _isSpeaking = false;
  bool _isPaused = false;

  String textToSpeak = ""; // Store the text once

  void _prepareText() {
    String plantName = widget.plant['plantName'] ?? 'Unknown';
    String scientificName = widget.plant['scientificName'] ?? 'Unknown';
    String tagalogName = widget.plant['tagalogName'] ?? 'Unknown';
    String description = widget.plant['description1'] ?? 'No description available.';
    String toxicityIndex = widget.plant['toxicityIndex'] ?? 'Unknown toxicity index';
    String toxicityDescription = widget.plant['toxicityDescription'] ?? 'No toxicity description available.';

    List<dynamic>? locations = widget.plant['location'];
    String location = (locations != null && locations.isNotEmpty)
        ? locations.map((loc) => loc['name']).join(', ')
        : 'Unknown';

    textToSpeak = '''
    $plantName.
    with a scientific name of $scientificName
    and a Tagalog term of $tagalogName.
    $description.
    It has a toxicity index of $toxicityIndex.
    $toxicityDescription.
    $plantName is commonly found in $location.
    ''';
  }

  // Play or Resume TTS
  Future<void> _speak() async {
    if (_isSpeaking) {
      _pause(); // If speaking, pause it
    } else if (_isPaused) {
      _resume(); // If paused, resume
    } else {
      await _flutterTts.speak(textToSpeak); // If stopped, start fresh
    }
  }

  // Pause TTS
  Future<void> _pause() async {
    var result = await _flutterTts.pause();
    if (result == 1) {
      setState(() {
        _isSpeaking = false;
        _isPaused = true;
      });
    }
  }

  // Resume TTS
  Future<void> _resume() async {
    var result = await _flutterTts.speak(textToSpeak);
    if (result == 1) {
      setState(() {
        _isSpeaking = true;
        _isPaused = false;
      });
    }
  }

  // Stop TTS
  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
      _isPaused = false;
    });
  }

  Future<void> _startFromBeginning() async {
    await _flutterTts.stop(); // Stop any ongoing speech
    setState(() {
      _isSpeaking = false;
      _isPaused = false;
    });
    await _flutterTts.speak(textToSpeak); // Start from the beginning
  }




  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
    // Stop the TTS when the widget is disposed
    _flutterTts.stop();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    developer.log('Connectivity changed: $_connectionStatus');
  }

  bool get _isConnected {
    return _connectionStatus.contains(ConnectivityResult.wifi) ||
        _connectionStatus.contains(ConnectivityResult.mobile);
  }

  Future<void> _getUserLocation() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData currentLocation = await location.getLocation();
    setState(() {
      _userLocation = currentLocation;
    });
  }

  Widget buildToxicityIndexBox(double width) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFB71C1C), width: 1.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB71C1C).withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with warning title
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFB71C1C), Color(0xFFE53935)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB71C1C).withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min, // Ensures the Row only takes up necessary space
            children: [
              Icon(Icons.warning_amber_outlined, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Toxicity Index',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        )
      ),


          const SizedBox(height: 20),

          // Toxicity index display
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3F3),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFFFCDD2), width: 1),
              ),
              child: Text(
                '${widget.plant['toxicityIndex'] ?? 'Not Available'}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFB71C1C),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Description with subtle background
          Container(
            padding: const EdgeInsets.all(18.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${widget.plant['toxicityDescription'] ?? 'No description available'}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF424242),
                height: 1.5,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Footer with hazard symbols
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dangerous, color: const Color(0xFFE53935).withOpacity(0.3), size: 16),
              const SizedBox(width: 8),
              Icon(Icons.warning_amber, color: const Color(0xFFE53935).withOpacity(0.5), size: 18),
              const SizedBox(width: 8),
              Icon(Icons.health_and_safety, color: const Color(0xFFE53935).withOpacity(0.7), size: 20),
              const SizedBox(width: 8),
              Icon(Icons.warning_amber, color: const Color(0xFFE53935).withOpacity(0.5), size: 18),
              const SizedBox(width: 8),
              Icon(Icons.dangerous, color: const Color(0xFFE53935).withOpacity(0.3), size: 16),
            ],
          ),
        ],
      ),
    );

  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Get the plant data from the list
    var plant = widget.plant;

    // Get the location data (latitude, longitude) for the plant
    var plantLocation = plant['location'];

    double latitude = 0.0; // Default fallback value
    double longitude = 0.0; // Default fallback value

    // Check if 'location' is not null and contains data
    if (plantLocation != null && plantLocation.isNotEmpty) {
      var location = plantLocation[0];
      latitude = location['latitude'] ?? 0.0; // Use a fallback if latitude is null
      longitude = location['longitude'] ?? 0.0; // Use a fallback if longitude is null
      print('Location found. Latitude: $latitude, Longitude: $longitude');
    } else {
      print('Location is null or empty. Using fallback values: latitude = $latitude, longitude = $longitude');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          plant['plantName'] ?? 'Unknown Plant', // Provide a default value in case it's null
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        color: const Color(0xFFE9FFC8),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add Padding widget to the CarouselSlider to apply top padding
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: carousel.CarouselSlider(
                  options: carousel.CarouselOptions(
                    height: 500,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.easeInOut,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: [
                    plant['image1'],
                    plant['image2'],
                    plant['image3'],
                    plant['image4'],
                  ].map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(imageUrl: image ?? 'assets/default_image.jpg'),
                              ),
                            );
                          },
                          child: Container(
                            width: screenWidth * 0.85,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF08411c), width: 3.0),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.5),
                              child: Hero(
                                tag: image ?? 'assets/default_image.jpg', // Unique tag for animation
                                child: Image.asset(
                                  image ?? 'assets/default_image.jpg', // Provide a default image if null
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == i ? const Color(0xFF4FAE50) : Colors.grey,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDescriptionBox(screenWidth),
              const SizedBox(height: 10),
              buildToxicityIndexBox(screenWidth),
              const SizedBox(height: 20),
// Displaying the Map with the plant's location
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text widget displaying plant name centered
                  Text(
                    'Where ${plant['plantName']} is commonly found', // Dynamic plant name
                    textAlign: TextAlign.center, // Center the text
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF08411c),
                    ),
                  ),
                  const SizedBox(height: 10), // Spacer between text and map

                  _isConnected
                      ? Container(
                    height: 500,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF08411c), width: 3.0),
                    ),
                    child: FlutterMap(
                      options: const MapOptions(
                        initialCenter: LatLng(12.8797, 121.7740),
                        initialZoom: 5.7,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            if (widget.plant['location'] != null)
                              for (var location in widget.plant['location'])
                                if (location['latitude'] != null && location['longitude'] != null)
                                  Marker(
                                    point: LatLng(
                                      location['latitude'],
                                      location['longitude'],
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40.0,
                                    ),
                                  ),
                            if (_userLocation != null)
                              Marker(
                                point: LatLng(
                                  _userLocation!.latitude!,
                                  _userLocation!.longitude!,
                                ),
                                child: Image.asset(
                                  'assets/images/gps2.png',
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                  :Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9, // Set width to 90% of the screen width
                      padding: const EdgeInsets.all(20.0), // Increased padding for better spacing
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3b3b3b), Color(0xFF222222)], // Dark gradient for background
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15), // Slightly rounder corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3), // Subtle shadow for depth
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Inner box with its own border
                          Container(
                            width: double.infinity, // Make the inner container take full width
                            padding: const EdgeInsets.all(20.0), // Padding for better spacing inside
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFF08411c), // Border color for the inner box
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(12), // More rounded corners for inner box
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1), // Light shadow for depth
                                  offset: const Offset(0, 2),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Iterate over the locations and display them with numbers
                                ...widget.plant['location'].asMap().map((index, location) {
                                  return MapEntry(
                                    index,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased vertical spacing
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${index + 1}. ",
                                            style: const TextStyle(
                                              color: Color(0xFF08411c), // Color for numbering
                                              fontSize: 20.0, // Slightly larger font for numbering
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              location['name'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).values.toList(),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15), // Increased space between the box and the message

                          // Place the "Connect to internet" message outside of the box and center it
                          const Center(
                            child: Text(
                              "Connect to internet to view map",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0, // Larger font size for better visibility
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center, // Center-align the message text
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),



                  const SizedBox(height: 20),
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          // Long press starts from the beginning
          await _flutterTts.stop(); // Stop any ongoing speech
          setState(() {
            _isSpeaking = false;
            _isPaused = false;
          });
          await _flutterTts.speak(textToSpeak); // Start from the beginning
        },
        child: FloatingActionButton(
          onPressed: () {
            if (_isSpeaking) {
              _pause(); // If speaking, pause it
            } else if (_isPaused) {
              _resume(); // If paused, resume
            } else {
              _flutterTts.speak(textToSpeak); // If stopped, start fresh
            }
          },
          backgroundColor: const Color(0xFF4FAE50),
          child: Icon(
            _isSpeaking
                ? Icons.pause // Show Pause when speaking
                : (_isPaused ? Icons.play_arrow : Icons.volume_up), // Show Play if paused, Speaker if idle
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Corrected location

    );

  }

  // This function builds the description box with improved aesthetics
  Widget _buildDescriptionBox(double width) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: width - 40,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF1A5D1A), width: 1.5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A5D1A).withOpacity(0.15),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with scientific name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A5D1A), Color(0xFF4FAE50)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A5D1A).withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.eco, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.plant['scientificName']!,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tagalog name with subtle divider
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8E9),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFAED581), width: 1),
              ),
              child: Text(
                'Also known as "${widget.plant['tagalogName']}"',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF558B2F),
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Description with subtle background
          Container(
            padding: const EdgeInsets.all(18.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBF9),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              widget.plant['description1']!,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
                height: 1.5,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Footer with leaf icons as decorative elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.eco, color: const Color(0xFF4FAE50).withOpacity(0.3), size: 16),
              const SizedBox(width: 8),
              Icon(Icons.eco, color: const Color(0xFF4FAE50).withOpacity(0.5), size: 18),
              const SizedBox(width: 8),
              Icon(Icons.eco, color: const Color(0xFF4FAE50).withOpacity(0.7), size: 20),
              const SizedBox(width: 8),
              Icon(Icons.eco, color: const Color(0xFF4FAE50).withOpacity(0.5), size: 18),
              const SizedBox(width: 8),
              Icon(Icons.eco, color: const Color(0xFF4FAE50).withOpacity(0.3), size: 16),
            ],
          ),
        ],
      ),
    );

  }

}

