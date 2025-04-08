import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';


import 'first_aid.dart';

class ScanPlantScreen extends StatefulWidget {
  final bool camera;
  final bool gallery;
  final bool _isSelectingPhoto = false; // Initialize as false
  const ScanPlantScreen({super.key, this.camera = false, this.gallery = false});

  @override
  _ScanPlantScreenState createState() => _ScanPlantScreenState();
}

class _ScanPlantScreenState extends State<ScanPlantScreen> {
  img.Image? _resizedImage;
  String? _imagePath;
  String _result = '';
  Interpreter? _interpreter;
  bool _isLoading = false;

  // List of class names
  List<String> classNames = [
    "Bulbous buttercup",
    "Clematis",
    "Copperleaf",
    "Crinum Lily",
    "Elephant's Ear",
    "Fishtail Palm",
    "Hydrangea",
    "Iris",
    "Pothos",
    "Stinging Nettle",
    "Invalid",
    "Non-Irritant",
  ];

  // Map to hold details for each plant
  final Map<String, Map<String, String>> plantDetails = {
    "Bulbous buttercup": {
      "scientificName": "Ranunculus bulbosus",
      "tagalogName": "Dilaw-dilawan",
      "toxicityIndex": "Minor Toxicity & Dermatitis",
      "plantDescription": "Small yellow-flowered plant commonly found in meadows.",
      "toxicityDescription": "Minor Toxicity: May cause mild symptoms like diarrhea or vomiting.\nDermatitis: Can cause skin irritation or rash.",
      "genus": "Ranunculus",
      "species": "bulbosus",
      "family": "Ranunculaceae",
      "img1" : "assets/images/library/1SN.png",
      "img2" : "assets/images/library/2SN.png",
      "img3" : "assets/images/library/3SN.png",
    },
    "Clematis": {
      "scientificName": "Clematis recta",
      "tagalogName": "Bagawak",
      "toxicityIndex": "Minor Toxicity & Dermatitis",
      "plantDescription": "Climbing flowering plant with colorful blooms, often grown in gardens.",
      "toxicityDescription": "Minor Toxicity: May cause mild symptoms like diarrhea or vomiting.\nDermatitis: Can cause skin irritation or rash.",
      "genus": "Clematis",
      "species": "recta",
      "family": "Ranunculaceae",
    },
    "Copperleaf": {
      "scientificName": "Acalypha wilkesiana",
      "tagalogName": "Buntot-pusa",
      "toxicityIndex": "Minor Toxicity & Dermatitis",
      "plantDescription": "Ornamental plant with coppery-colored leaves, popular in landscaping.",
      "toxicityDescription": "Minor Toxicity: May cause mild symptoms like diarrhea or vomiting.\nDermatitis: Can cause skin irritation or rash.",
      "genus": "Acalypha",
      "species": "wilkesiana",
      "family": "Euphorbiaceae",
    },
    "Crinum Lily": {
      "scientificName": "Crinum asiaticum",
      "tagalogName": "Bakong",
      "toxicityIndex": "Minor Toxicity & Dermatitis",
      "plantDescription": "Large lily-like plant with fragrant white flowers.",
      "toxicityDescription": "Minor Toxicity: May cause mild symptoms like diarrhea or vomiting.\nDermatitis: Can cause skin irritation or rash.",
      "genus": "Crinum",
      "species": "asiaticum",
      "family": "Amaryllidaceae",
    },
    "Elephant's Ear": {
      "scientificName": "Colocasia esculenta",
      "tagalogName": "Gabi",
      "toxicityIndex": "Oxalates & Dermatitis",
      "plantDescription": "Large, heart-shaped leaves; often found in tropical areas.",
      "toxicityDescription": "Oxalates: Can cause throat swelling, breathing issues, and burning pain.\nDermatitis: Can cause skin irritation or rash.",
      "genus": "Colocasia",
      "species": "esculenta",
      "family": "Araceae",
    },
    "Fishtail Palm": {
      "scientificName": "Caryota mitis",
      "tagalogName": "Pugahan",
      "toxicityIndex": "Oxalates & Dermatitis",
      "plantDescription": "Unique palm with fishtail-shaped leaves, common in landscaping.",
      "toxicityDescription": "Oxalates: Can cause throat swelling, breathing issues, and burning pain.\nDermatitis: Can cause skin irritation or rash.",
      "genus": "Caryota",
      "species": "mitis",
      "family": "Arecaceae",
    },
    "Hydrangea": {
      "scientificName": "Hydrangea macrophylla",
      "tagalogName": "Hortensia",
      "toxicityIndex": "Major Toxicity & Dermatitis",
      "plantDescription": "Flowering plant with colorful clustered blooms, often seen in gardens.",
      "toxicityDescription": "Major Toxicity: Can cause severe illness or death.\nDermatitis: Can cause skin irritation or rash.",
      "genus": "Hydrangea",
      "species": "macrophylla",
      "family": "Hydrangeaceae",
    },
    "Iris": {
      "scientificName": "Trimezia coerulea",
      "tagalogName": "Lirio",
      "toxicityIndex": "Minor Toxicity & Dermatitis",
      "plantDescription": "Ornamental flowering plant with showy, colorful blooms.",
      "toxicityDescription": "Minor Toxicity: May cause mild symptoms like diarrhea or vomiting.\nDermatitis: Can cause skin irritation or rash.",
      "genus": "Trimezia",
      "species": "coerulea",
      "family": "Iridaceae",
    },
    "Pothos": {
      "scientificName": "Epipremnum aureum",
      "tagalogName": "Dilang-baka",
      "toxicityIndex": "Oxalates & Dermatitis",
      "plantDescription": "Trailing plant popular in indoor gardening, with heart-shaped leaves.",
      "toxicityDescription": "Oxalates: Can cause throat swelling, breathing issues, and burning pain.\nDermatitis: Can cause skin irritation or rash.",
      "genus": "Epipremnum",
      "species": "aureum",
      "family": "Araceae",
    },
    "Stinging Nettle": {
      "scientificName": "Urtica dioica",
      "tagalogName": "Lipang Aso",
      "toxicityIndex": "Dermatitis",
      "plantDescription": "Herbaceous plant with fine stinging hairs on the leaves and stems.",
      "toxicityDescription": "Dermatitis: Causes painful skin irritation or rash upon contact.",
      "genus": "Urtica",
      "species": "dioica",
      "family": "Urticaceae",
    },
    "Invalid": {
      "scientificName": "Invalid",
      "tagalogName": "Invalid",
      "toxicityIndex": "Invalid",
      "plantDescription": "This may be due to one or more of the following reasons:\\n- The image is not a plant.\\n- The plant is toxic but not an irritant type.\\n- The photo has low visibility or insufficient light.\\n- The picture is not clear or is improperly taken.",
      "toxicityDescription": "Invalid",
      "genus": "Invalid",
      "species": "Invalid",
      "family": "Invalid",
    },
    "Non-Irritant": {
      "scientificName": "Non-Irritant",
      "tagalogName": "Non-Irritant",
      "toxicityIndex": "Non-Irritant",
      "plantDescription": "This may be due to one or more of the following reasons:\\n- The plant is toxic but not an irritant type. \\n- The plant may not be toxic in nature.",
      "toxicityDescription": "Non-Irritant",
      "genus": "Non-Irritant",
      "species": "Non-Irritant",
      "family": "Non-Irritant",
    },
  };

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // TTS variables
  FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _isPaused = false;
  String _speechText = "";

  @override
  void initState() {
    super.initState();
    _loadModel();

    if (widget.camera) {
      _pickImage(ImageSource.camera);
    } else if (widget.gallery) {
      _pickImage(ImageSource.gallery);
    }

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // Initialize TTS handlers
    _initTts();
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

  Future<void> _speak() async {
    if (_result.contains('Invalid')) {
      await _flutterTts.speak(
          "The image is invaughlid. This may be due to one or more of the following reasons: The image is not a plant. The photo has low visibility or insufficient light. The picture is not clear or is improperly taken."
      );
      return;
    }

    else if (_result.contains('Non-Irritant')) {
      await _flutterTts.speak(
          "The plant is classified as non-irritant. This may be due to one or more of the following reasons: The plant is toxic but not an irritant type, or the plant may not be toxic in nature."
      );
      return;
    }


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
    if (_result.isEmpty) return;

    List<String> resultLines = _result.split('\n');
    String plantName = resultLines[0].replaceFirst('Predicted class: ', '').trim();
    String accuracy = resultLines[1].replaceFirst('Accuracy: ', '').replaceAll('%', '').trim();
    String scientificName = resultLines[2].trim();
    String tagalogName = resultLines[3].trim();
    String genus = resultLines[4].trim();
    String species = resultLines[5].trim();
    String family = resultLines[6].trim();
    String toxicityIndex = resultLines[7].trim();
    String plantDescription = resultLines[8].trim();
    String toxicityDescription = resultLines.sublist(9).join(' ').trim();

    _speechText = """
    The plant is identified as $plantName with an accuracy of $accuracy percent. 
    Its toxicity index is $toxicityIndex. $toxicityDescription. 
    $plantName, scientifically known as $scientificName. 
    In the Philippines, it is referred to as $tagalogName. 
    This plant belongs to the $genus genus and its species name is $species. 
    It is part of the $family family. $plantName, $plantDescription
    """;
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

  Future<void> _startFromBeginning() async {
    await _stop();
    await _prepareSpeechText();
    await _speak();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  bool get _isConnected {
    return _connectionStatus.contains(ConnectivityResult.wifi) ||
        _connectionStatus.contains(ConnectivityResult.mobile);
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/modelnewnontoxic.tflite');
      print('Model loaded successfully!');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile == null) {
        Navigator.pop(context);
        return;
      }

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) {
        Navigator.pop(context);
        return;
      }

      setState(() {
        _imagePath = croppedFile.path;
        _isLoading = true;
      });

      _loadAndResizeImage(croppedFile.path);
    } catch (e) {
      print('Error picking and cropping image: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAndResizeImage(String path) async {
    try {
      final file = File(path);
      final imageBytes = await file.readAsBytes();
      img.Image originalImage = img.decodeImage(imageBytes)!;
      _resizedImage = img.copyResize(originalImage, width: 299, height: 299);
      await _analyzeImage(_resizedImage!);
      setState(() {});
    } catch (e) {
      print('Error loading and resizing image: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _analyzeImage(img.Image image) async {
    try {
      var inputTensor = List.generate(
        1,
            (b) => List.generate(
          299,
              (i) => List.generate(
            299,
                (j) {
              var pixel = image.getPixel(j, i);
              return [
                img.getRed(pixel) / 255.0,
                img.getGreen(pixel) / 255.0,
                img.getBlue(pixel) / 255.0,
              ];
            },
          ),
        ),
      );

      var output = List.filled(1 * 12, 0.0).reshape([1, 12]);

      if (_interpreter != null) {
        _interpreter!.run(inputTensor, output);
      }

      // Function to check for green shades in the image
      bool checkForGreenShades(img.Image image) {
        int greenPixelCount = 0;
        int totalPixels = image.width * image.height;

        for (int y = 0; y < image.height; y++) {
          for (int x = 0; x < image.width; x++) {
            int pixel = image.getPixel(x, y);
            int red = img.getRed(pixel);
            int green = img.getGreen(pixel);
            int blue = img.getBlue(pixel);

            // If the green component is higher than the others, consider it a green shade
            if (green > red && green > blue) {
              greenPixelCount++;
            }
          }
        }

        // If the number of green pixels exceeds 20% of the total pixels, consider it as having green shades
        return greenPixelCount / totalPixels > 0.2;
      }


      setState(() {
        List<double> outputValues = output[0].cast<double>();
        double confidenceScore = outputValues.reduce((a, b) => a > b ? a : b);
        int predictedClassIndex = confidenceScore >= 0.8
            ? outputValues.indexOf(confidenceScore)
            : 10; // Use index 10 for "Invalid"

        String predictedClassName = classNames[predictedClassIndex];

        // Logic to check "Non-Irritant" class (index 11)
        if (predictedClassName == "Non-Irritant" && confidenceScore < 0.9) {
          predictedClassName = "Invalid";  // Mark as invalid if "Non-Irritant" has low confidence
          confidenceScore = 0.0;  // Set confidence to 0 since it's invalid
        }

        // Keeping "Invalid" class even if confidence is low (below 70%)
        if (predictedClassName == "Invalid" && confidenceScore < 0.7) {
          confidenceScore = 0.0;  // Set confidence to 0, but still classify as "Invalid"
        }

        // Check for green shades in the image if predicted class is "Non-Irritant"
        if (predictedClassName == "Non-Irritant") {
          bool hasGreenShades = checkForGreenShades(image); // Call the function to check for green tones
          if (!hasGreenShades) {
            predictedClassName = "Invalid"; // Mark as invalid if no green shades
            confidenceScore = 0.0; // Set confidence to 0
          }
        }

        var details = predictedClassName != "Invalid"
            ? plantDetails[predictedClassName]
            : {
          "scientificName": "Invalid",
          "tagalogName": "Invalid",
          "toxicityIndex": "Invalid",
          "plantDescription": "This may be due to one or more of the following reasons:\\n- The image is not a plant.\\n- The photo has low visibility or insufficient light.\\n- The picture is not clear or is improperly taken.",
          "toxicityDescription": "Invalid",
          "genus": "Invalid",
          "species": "Invalid",
          "family": "Invalid",
        };

        print('Accuracy: ${confidenceScore * 100}%');
        print('Predicted Class: $predictedClassName');
        print('ClassNames length: ${classNames.length}');
        print('PredictedClassIndex: $predictedClassIndex');

        _result = 'Predicted class: $predictedClassName\n';

        String scientificName = '';
        for (String line in _result.split('\n')) {
          if (line.startsWith('Scientific Name:')) {
            scientificName = line.replaceFirst('Scientific Name: ', '').trim();
            break;
          }
        }

        _result +=
        'Accuracy: ${(confidenceScore * 100).round()}%\n'
            '${details?["scientificName"]}\n'
            '${details?["tagalogName"]}\n'
            '${details?["genus"]}\n'
            '${details?["species"]}\n'
            '${details?["family"]}\n'
            '${details?["toxicityIndex"]}\n'
            '${details?["plantDescription"]}\n'
            '${details?["toxicityDescription"]}\n';

        _isLoading = false;
      });




    } catch (e) {
      print('Error analyzing image: $e');
      setState(() {
        _isLoading = false;
        _result = 'Error analyzing image.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth * 0.90;


    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan Plant',
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
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : _result.isEmpty
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_imagePath != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      width: boxWidth,
                      height: 400,
                      child: Image.file(
                        File(_imagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],

                if (!_result.contains('Invalid') && !_result.contains("Non-Irritant")) ...[
                  Text(
                    _result.split('\n').isNotEmpty &&
                        _result.split('\n')[0].length > 15
                        ? _result
                        .split('\n')[0]
                        .substring(_result.split('\n')[0].indexOf(':') + 1)
                        .trim()
                        : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black87,
                    ),
                  ),

                  Text(
                    _result.split('\n').length > 1
                        ? _result.split('\n')[1]
                        : '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Container(
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color: _result.contains('Invalid') || _result.contains("Non-Irritant")
                        ? const Color(0xFF363636)
                        : Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _result.contains('Invalid') ? 'INVALID' :
                    _result.contains("Non-Irritant") ? 'NON-IRRITANT' :
                    'IRRITANT',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10),

                if (!_result.contains('Invalid') && !_result.contains("Non-Irritant")) ...[
                  Container(
                    width: boxWidth,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title
                        const Text(
                          'Toxicity Index:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        // Toxicity Score
                        Container(
                          width: boxWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4FAE50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          margin: EdgeInsets.symmetric(horizontal: boxWidth * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.eco, color: Colors.white),
                              Text(
                                _result.split('\n').length > 1
                                    ? _result.split('\n')[7].trim()
                                    : '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Toxicity Details with Icons
                        Column(
                          children: _result.split('\n').length > 2
                              ? _result
                              .split('\n')
                              .sublist(8)
                              .where((line) => line.contains(':'))
                              .map((line) {
                            List<String> parts = line.split(':');
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${parts[0].trim()}: ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          TextSpan(
                                            text: parts.sublist(1).join(':').trim(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList()
                              : [],
                        ),
                      ],
                    ),
                  )

                ],
                const SizedBox(height: 10),
                Container(
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),

                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          _result.contains('Invalid')
                              ? 'The image is invalid.'
                              : _result.contains("Non-Irritant")
                              ? 'Image is non-irritant.'
                              : _result.split('\n').isNotEmpty &&
                              _result.split('\n')[0].length > 15
                              ? _result
                              .split('\n')[0]
                              .substring(_result.split('\n')[0].indexOf(':') + 1)
                              .trim()
                              : '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),


                      if (_result.contains('Invalid') || _result.contains("Non-Irritant")) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F0),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey, width: 2),
                          ),
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            _result.split('\n').length > 8
                                ? _result.split('\n')[8].trim().replaceAll('\\n', '\n')
                                : '',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ] else if (!_result.contains('Invalid') && !_result.contains("Non-Irritant")) ...[
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Scientific Name: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: _result.split('\n').length > 2 ? _result.split('\n')[2].trim() : '',
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Tagalog Name: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: _result.split('\n').length > 5 ? _result.split('\n')[3].trim() : '',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Genus: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: _result.split('\n').length > 4 ? _result.split('\n')[4].trim() : '',
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Species: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: _result.split('\n').length > 5 ? _result.split('\n')[5].trim() : '',
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Family: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: _result.split('\n').length > 5 ? _result.split('\n')[6].trim() : '',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F0),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFD9D5CA), width: 2),
                          ),
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            _result.isEmpty
                                ? ''
                                : _result.split('\n').length > 1
                                ? _result.split('\n')[8].trim().replaceAll('\\n', '\n')
                                : '',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),


                if (!_result.contains('Invalid') && !_result.contains("Non-Irritant")) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _flutterTts.stop();
                        String predictedClass = _result.isEmpty
                            ? ''
                            : _result.split('\n').isNotEmpty && _result.split('\n')[0].length > 15
                            ? _result.split('\n')[0].substring(
                          _result.split('\n')[0].indexOf(':') + 1,
                        ).trim()
                            : '';
                        String toxicityIndex = _result.split('\n').length > 3
                            ? _result.split('\n')[7].trim()
                            : '';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstAid(predictedClass: predictedClass, toxicityIndex: toxicityIndex,),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4fae53),
                        minimumSize: Size(boxWidth, 60),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Color(0xFF08411c),
                            width: 5,
                          ),
                        ),
                      ),
                      child: const Text(
                        'First Aid Guide',
                        style: TextStyle(
                          color: Color(0xFF08411c),
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onLongPress: () async {
          await _startFromBeginning();
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