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

  FullScreenImagePage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Close the full-screen view when tapped
          },
          child: Hero(
            tag: imageUrl,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
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

  FlutterTts _flutterTts = FlutterTts(); // Initialize FlutterTts

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

  // This function builds the box displaying the toxicity index
  Widget buildToxicityIndexBox(double width) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF990000), width: 3.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'Toxicity Index',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${widget.plant['toxicityIndex'] ?? 'Not Available'}', // Default value if null
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF990000), width: 2.0),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '${widget.plant['toxicityDescription'] ?? 'No description available'}', // Default value if null
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Get the plant data from the list (assuming widget.plant is a map from your list)
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
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3b3b3b), // Background color
                        borderRadius: BorderRadius.circular(10), // Outer Border radius
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                        children: [
                          // Inner box with its own border, extending to the full width of the parent container
                          Container(
                            width: double.infinity, // Make the inner container take the full width
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFF08411c), // Border color for inner box
                                width: 2.0, // Border width for inner box
                              ),
                              borderRadius: BorderRadius.circular(5), // Border radius for inner box
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Iterate over the locations and display them with numbers
                                ...widget.plant['location']
                                    .asMap()
                                    .map((index, location) {
                                  return MapEntry(
                                    index,
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 0.5), // Reduced space between each location
                                      child: Text(
                                        "${index + 1}. ${location['name']}", // Add numbering before location
                                        style: const TextStyle(
                                          color: Colors.black, // Text color to match the border
                                          fontSize: 18.0, // Smaller font size for compression
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                    .values
                                    .toList(),
                              ],
                            ),
                          ),
                          // Place the "Connect to internet" message outside of the box and center it
                          const SizedBox(height: 10), // Reduced space between the box and the message
                          const Center( // Center the message
                            child: Text(
                              "Connect to internet to view map",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
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

  // This function builds the description box
  Widget _buildDescriptionBox(double width) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: width - 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF08411c), width: 3.0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: width * 0.9,
            decoration: BoxDecoration(
              color: const Color(0xFF4FAE50),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              widget.plant['scientificName']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic,),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Also known as "${widget.plant['tagalogName']}"',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.grey, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(10.0),
            width: width - 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF08411c), width: 2.0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.plant['description1']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

