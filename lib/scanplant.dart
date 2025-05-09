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
      "img1" : "assets/images/library/5BC.png",
      "img2" : "assets/images/library/2BC.png",
      "img3" : "assets/images/library/3BC.png",
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
      "img1" : "assets/images/library/4CL.png",
      "img2" : "assets/images/library/2CL.png",
      "img3" : "assets/images/library/5CL.png",
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
      "img1" : "assets/images/library/1CP.png",
      "img2" : "assets/images/library/2CP.png",
      "img3" : "assets/images/library/3CP.png",
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
      "img1" : "assets/images/library/1LY.png",
      "img2" : "assets/images/library/2LY.png",
      "img3" : "assets/images/library/3LY.png",
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
      "img1" : "assets/images/library/1EP.png",
      "img2" : "assets/images/library/2EP.png",
      "img3" : "assets/images/library/3EP.png",
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
      "img1" : "assets/images/library/1FT.png",
      "img2" : "assets/images/library/2FT.png",
      "img3" : "assets/images/library/3FT.png",
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
      "img1" : "assets/images/library/1HY.png",
      "img2" : "assets/images/library/2HY.png",
      "img3" : "assets/images/library/3HY.png",
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
      "img1" : "assets/images/library/1IR.png",
      "img2" : "assets/images/library/2IR.png",
      "img3" : "assets/images/library/3IR.png",
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
      "img1" : "assets/images/library/1PH.png",
      "img2" : "assets/images/library/2PH.png",
      "img3" : "assets/images/library/3PH.png",
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
      "img1" : "assets/images/library/1SN.png",
      "img2" : "assets/images/library/2SN.png",
      "img3" : "assets/images/library/3SN.png",
    },
    "Invalid": {
      "scientificName": "Invalid",
      "tagalogName": "Invalid",
      "toxicityIndex": "Invalid",
      "plantDescription": "This may be due to one or more of the following:\\n- The image is not a plant.\\n- The photo has low visibility or insufficient light.\\n- The picture is not clear or is improperly taken.",
      "toxicityDescription": "Invalid",
      "genus": "Invalid",
      "species": "Invalid",
      "family": "Invalid",

    },
    "Non-Irritant": {
      "scientificName": "Non-Irritant",
      "tagalogName": "Non-Irritant",
      "toxicityIndex": "Non-Irritant",
      "plantDescription": "This plant does not cause skin irritation and is considered safe to touch under normal conditions or handling.",
      "toxicityDescription": "Non-Irritant",
      "genus": "Non-Irritant",
      "species": "Non-Irritant",
      "family": "Non-Irritant",
      "img1" : "assets/images/library/1SN.png",
      "img2" : "assets/images/library/2SN.png",
      "img3" : "assets/images/library/3SN.png",
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


  List<String> _imagePaths = [];

  Future<void> fetchImagePaths(String plantName) async {
    if (plantDetails.containsKey(plantName)) {
      final plant = plantDetails[plantName]!;
      _imagePaths = [
        plant["img1"] ?? '',
        plant["img2"] ?? '',
        plant["img3"] ?? '',
      ];
    } else {
      _imagePaths = [];
    }
  }



  Future<void> _speak() async {
    if (_isSpeaking) {
      await _pause();
      return;
    } else if (_isPaused) {
      await _resume();
      return;
    }

    // Prepare speech text for all cases
    await _prepareSpeechText();

    // Speak the prepared text
    await _flutterTts.speak(_speechText);
  }

  Future<void> _prepareSpeechText() async {
    if (_result.isEmpty) return;

    if (_result.contains('Invalid')) {
      _speechText = "The image is invaughlid. This may be due to one or more of the following: "
          "The image is not a plant. The photo has low visibility or insufficient light. "
          "The picture is not clear or is improperly taken.";
      return;
    }

    if (_result.contains('Non-Irritant')) {
      _speechText = "The plant is classified as non-irritant. This plant does not cause skin irritation and is considered safe to touch under normal conditions or handling.";
      return;
    }

    // Regular plant description handling
    List<String> resultLines = _result.split('\n');
    String plantName = resultLines[0].replaceFirst('Predicted class: ', '').trim();
    String accuracy = resultLines[1].replaceFirst('Probability: ', '').replaceAll('%', '').trim();
    String scientificName = resultLines[2].trim();
    String tagalogName = resultLines[3].trim();
    String genus = resultLines[4].trim();
    String species = resultLines[5].trim();
    String family = resultLines[6].trim();
    String toxicityIndex = resultLines[7].trim();
    String plantDescription = resultLines[8].trim();
    String toxicityDescription = resultLines.sublist(9).join(' ').trim();

    _speechText = """
    The plant is identified as $plantName with a probability of $accuracy percent.
    This plant is toxic irritant. 
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


      setState(() async {
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
        await fetchImagePaths(predictedClassName);

        var details = predictedClassName != "Invalid"
            ? plantDetails[predictedClassName]
            : {
          "scientificName": "Invalid",
          "tagalogName": "Invalid",
          "toxicityIndex": "Invalid",
          "plantDescription": "This may be due to one or more of the following:\\n- The image is not a plant.\\n- The photo has low visibility or insufficient light.\\n- The picture is not clear or is improperly taken.",
          "toxicityDescription": "Invalid",
          "genus": "Invalid",
          "species": "Invalid",
          "family": "Invalid",
        };

        print('Probability: ${confidenceScore * 100}%');
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
        'Probability: ${(confidenceScore * 100).round()}%\n'
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
                    color: _result.contains('Invalid')
                        ? const Color(0xFF363636)
                        : _result.contains("Non-Irritant")
                        ? const Color(0xFF4FAE50)
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
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_result.contains('Invalid'))
                        Image.asset(
                          'assets/images/wrong.png',
                          height: 30,
                          width: 30,
                          color: Colors.white,
                        )
                      else if (_result.contains('Non-Irritant'))
                        Image.asset(
                          'assets/images/check.png',
                          height: 30,
                          width: 30,
                        )
                      else
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      const SizedBox(width: 10),
                      Text(
                        _result.contains('Invalid')
                            ? 'INVALID'
                            : _result.contains("Non-Irritant")
                            ? 'NON-IRRITANT'
                            : 'TOXIC (IRRITANT)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
                      if (!_result.contains('Invalid') && !_result.contains("Non-Irritant")) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _imagePaths.map((path) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    backgroundColor: Colors.black.withOpacity(0.8),
                                    insetPadding: const EdgeInsets.all(16),
                                    child: InteractiveViewer(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          path,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 120),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      path,
                                      height: 100,
                                      width: 90,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 90),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                      ],




                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

                        decoration: BoxDecoration(
                          color: _result.contains('Invalid')
                              ? const Color(0xFFA6A6A6)
                              : _result.contains("Non-Irritant")
                              ? const Color(0xFFDFF5E2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _result.contains("Invalid")
                                ? Colors.black
                                : _result.contains("Non-Irritant")
                                ? const Color(0xFF4FAE50)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          _result.contains('Invalid')
                              ? 'The image is invalid'
                              : _result.contains("Non-Irritant")
                              ? 'The plant is non-irritant'
                              : _result.split('\n').isNotEmpty &&
                              _result.split('\n')[0].length > 15
                              ? _result
                              .split('\n')[0]
                              .substring(_result.split('\n')[0].indexOf(':') + 1)
                              .trim()
                              : '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: _result.contains("Invalid")
                                ? Colors.black
                                : _result.contains("Non-Irritant")
                                ? const Color(0xFF309c39)
                                : Colors.black87,
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
                            : _result.split('\n').isNotEmpty &&
                            _result.split('\n')[0].length > 15
                            ? _result
                            .split('\n')[0]
                            .substring(_result.split('\n')[0].indexOf(':') + 1)
                            .trim()
                            : '';
                        String toxicityIndex = _result.split('\n').length > 3
                            ? _result.split('\n')[7].trim()
                            : '';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstAid(
                              predictedClass: predictedClass,
                              toxicityIndex: toxicityIndex,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4fae53),
                        minimumSize: Size(boxWidth, 60),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                            color: Color(0xFF08411c),
                            width: 5,
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.medical_services, color: Color(0xFF08411c), size: 35),
                          SizedBox(width: 10),
                          Text(
                            'First Aid Guide',
                            style: TextStyle(
                              color: Color(0xFF08411c),
                              fontWeight: FontWeight.bold,
                              fontSize: 33,
                            ),
                          ),
                        ],
                      )

                    ),
                  ),
                ],
                const SizedBox(height: 60),
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