import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class FirstAid extends StatefulWidget {
  final String predictedClass;
  final String toxicityIndex;

  const FirstAid({
    super.key,
    required this.predictedClass,
    required this.toxicityIndex,
  });

  @override
  State<FirstAid> createState() => _FirstAidState();
}

class _FirstAidState extends State<FirstAid> {
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

  // TTS variables
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _isPaused = false;
  String _speechText = "";

  // Connectivity variables
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initTts();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  void _initTts() {
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

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
        _isPaused = false;
      });
    });
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  // Method to launch the dialer with the specified number
  Future<void> _callEmergency() async {
    _flutterTts.stop();
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

  Future<void> _speak() async {
    if (_isSpeaking) {
      await _pause();
    } else if (_isPaused) {
      await _resume();
    } else {
      await _prepareSpeechText();
      await _flutterTts.speak(_speechText);
    }
  }

  Future<void> _prepareSpeechText() async {
    // Split toxicityIndex into words (toxicity levels)
    final List<String> toxicityLevels = widget.toxicityIndex.split(RegExp(r'\s+'));

    // Get details for each matched toxicity level
    final List<Map<String, dynamic>> matchedToxicityDetails = toxicityLevels
        .map((level) {
      return toxicityInfo.firstWhere(
            (info) => info['level'] == level,
        orElse: () => <String, dynamic>{},
      );
    })
        .where((details) => details.isNotEmpty)
        .toList();

    // Build the speech text
    StringBuffer speechBuffer = StringBuffer();
    speechBuffer.write("First aid guide for ${widget.predictedClass}. ");
    speechBuffer.write("Toxicity Index: ${widget.toxicityIndex}. ");

    for (var details in matchedToxicityDetails) {
      speechBuffer.write("Toxicity Level: ${details['level']}. ");
      speechBuffer.write("Description: ${details['description']}. ");
      speechBuffer.write("Symptoms: ${details['symptoms']}. ");
      speechBuffer.write("First Aid Guide: ");

      if (details['firstAidGuide'] != null) {
        for (var i = 0; i < details['firstAidGuide'].length; i++) {
          speechBuffer.write("Step ${i + 1}: ${details['firstAidGuide'][i]}. ");
        }
      }
    }

    setState(() {
      _speechText = speechBuffer.toString();
    });
  }

  Future<void> _pause() async {
    var result = await _flutterTts.pause();
    if (result == 1) {
      setState(() {
        _isSpeaking = false;
        _isPaused = true;
      });
    }
  }

  Future<void> _resume() async {
    var result = await _flutterTts.speak(_speechText);
    if (result == 1) {
      setState(() {
        _isSpeaking = true;
        _isPaused = false;
      });
    }
  }

  Future<void> _stop() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
      _isPaused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Split toxicityIndex into words (toxicity levels)
    final List<String> toxicityLevels = widget.toxicityIndex.split(RegExp(r'\s+'));

    // Get details for each matched toxicity level
    final List<Map<String, dynamic>> matchedToxicityDetails = toxicityLevels
        .map((level) {
      return toxicityInfo.firstWhere(
            (info) => info['level'] == level,
        orElse: () => <String, dynamic>{},
      );
    })
        .where((details) => details.isNotEmpty)
        .toList();

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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // First aid guide section
                // First aid guide section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,  // Center the content horizontally
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${widget.predictedClass}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,  // Ensure the text is centered within the available space
                          ),

                        ],
                      ),
                      // Wrapping the indicators in a container that will shrink or expand as needed

                    ],
                  ),
                ),


                const SizedBox(height: 10),

                const SizedBox(height: 10),
                // Loop through each matched toxicity level and display its details
                for (var details in matchedToxicityDetails) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),

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

                          Image.asset(
                            details['img'] ?? 'assets/images/firstaidImg/major.JPG',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.contain,
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E2E2),
                              border: Border.all(color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(5),
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
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          await _stop();
          await _prepareSpeechText();
          await _speak();
        },
        child: FloatingActionButton(
          onPressed: _speak,
          backgroundColor: const Color(0xFF4FAE50),
          child: Icon(
            _isSpeaking
                ? Icons.pause
                : (_isPaused ? Icons.play_arrow : Icons.volume_up),
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}