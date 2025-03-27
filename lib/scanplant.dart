import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';

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
      "plantDescription": "This may be due to one or more of the following reasons:\\n- The plant is toxic but not an irritant type.\\n- The photo has low visibility or insufficient light.\\n- The picture is not clear or is improperly taken.",
      "toxicityDescription": "Invalid",
      "genus": "Invalid",
      "species": "Invalid",
      "family": "Invalid",
    },
  };

  @override
  void initState() {
    super.initState();
    _loadModel();

    if (widget.camera) {
      _pickImage(ImageSource.camera);
    } else if (widget.gallery) {
      _pickImage(ImageSource.gallery);
    }
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/model.tflite');
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

      // Define the output tensor for 13 classes (adjusted based on model).
      var output = List.filled(1 * 11, 0.0).reshape([1, 11]);

      if (_interpreter != null) {
        _interpreter!.run(inputTensor, output);
      }

      setState(() {
        List<double> outputValues = output[0].cast<double>();
        double confidenceScore = outputValues.reduce((a, b) => a > b ? a : b);
        int predictedClassIndex = confidenceScore >= 0.7
            ? outputValues.indexOf(confidenceScore)
            : 10; // Use index 10 for "Invalid"

        String predictedClassName = classNames[predictedClassIndex];

        // Check for "Invalid" class
        var details = predictedClassName != "Invalid"
            ? plantDetails[predictedClassName]
            : {
          "scientificName": "Invalid",
          "tagalogName": "Invalid",
          "toxicityIndex": "Invalid",
          "plantDescription": "This may be due to one or more of the following reasons:\\n- The image is not a plant.\\n- The plant is toxic but not an irritant type.\\n- The photo has low visibility or insufficient light.\\n- The picture is not clear or is improperly taken.",
          "toxicityDescription": "Invalid",
          "genus": "Invalid",
          "species": "Invalid",
          "family": "Invalid",
        };

        // Display the Accuracy in the console
        print('Accuracy: ${confidenceScore * 100}%');
        print('Predicted Class: $predictedClassName');
        print('classNames length: ${classNames.length}');
        print('predictedClassIndex: $predictedClassIndex');

        // Prepare the text for display
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
            '${details?["toxicityDescription"]}\n'
        ;
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
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;
    // Calculate the width for the boxes, reducing by a small margin (5%)
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
            Navigator.pop(context); // Go back to Dashboard
          },
        ),
        centerTitle: true,
      ),

        body: Container(
          color: const Color(0xFFE9FFC8),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _result.isEmpty // Check if the result is empty
                ? const CircularProgressIndicator() // Show loading indicator


        : SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image display
                if (_imagePath != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      width: boxWidth, // Set width to match the calculated box width
                      height: 400, // Set a fixed height for the image
                      child: Image.file(
                        File(_imagePath!),
                        fit: BoxFit.cover, // Use BoxFit to fill the space appropriately
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],

                // Display only the predicted class value
                if (!_result.contains('Invalid')) ...[
                  Text(
                    _result.split('\n').isNotEmpty &&
                        _result.split('\n')[0].length > 15
                        ? _result
                        .split('\n')[0]
                        .substring(_result.split('\n')[0].indexOf(':') + 1)
                        .trim() // Extract predicted class
                        : '',
                    textAlign: TextAlign.center, // Center the text
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.black87,
                    ),
                  ),
                  // Display the accuracy under the predicted class value
                  Text(
                    _result.split('\n').length > 1
                        ? _result.split('\n')[1] // Accuracy
                        : '',
                    textAlign: TextAlign.center, // Center the text
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                // Box with dynamic text (either "TOXIC" or "Invalid") and color change based on result
                Container(
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color: _result.contains('Invalid')
                        ? const Color(0xFF363636)
                        : Colors.red, // Keep red color for "TOXIC"
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: _result.contains('Invalid')
                          ? const Color(0xFF000000)
                          : const Color(0xFF980000),
                      width: 3, // Set border width
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0), // Padding inside the box
                  child: Text(
                    _result.contains('Invalid') ? 'INVALID' : 'TOXIC', // Change text based on result
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 10), // Space between "TOXIC" box and toxicity index

                // Container for Toxicity Index
                if (!_result.contains('Invalid')) ...[
                  Container(
                    width: boxWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: const Color(0xFF4FAE50), width: 3),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Toxicity Index:', // Label for the index
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        // Nested Container for Toxicity Index Value
                        Container(
                          width: boxWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4FAE50),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          margin: EdgeInsets.symmetric(horizontal: boxWidth * 0.01),
                          child: Center(
                            child: Text(
                              _result.split('\n').length > 1
                                  ? _result.split('\n')[7].trim()
                                  : '', // Provide an empty string if there's no value
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Toxicity description
                        Container(
                          alignment: Alignment.center, // Align the text to the left
                          child: RichText(
                            text: TextSpan(
                              children: _result.split('\n').length > 2
                                  ? _result.split('\n').sublist(8).expand<InlineSpan>((line) {
                                if (line.isNotEmpty) {
                                  // Split each line into label and description
                                  List<String> parts = line.split(':');
                                  if (parts.length > 1) {
                                    return [
                                      // Bold label
                                      TextSpan(
                                        text: parts[0] + ': ', // Label followed by a colon
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          height: 1.5,
                                          color: Colors.black87, // Black text color for the label
                                        ),
                                      ),
                                      // Regular description text
                                      TextSpan(
                                        text: parts[1].trim(), // Description text
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black87, // Black text color for the description
                                        ),
                                      ),
                                      const TextSpan(text: '\n'), // Add newline after each line
                                    ];
                                  }
                                }
                                return []; // Return an empty list if the line is empty
                              }).toList() // Convert the expanded Iterable to a list
                                  : [],
                              style: const TextStyle(
                                // Optional: Set a default style for the text
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ], // If not Invalid
                const SizedBox(height: 10), // Space between toxicity index and the new info box
                // Container for additional plant information
                Container(
                  width: boxWidth, // Set width to align with the other boxes
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color for the info box
                    borderRadius: BorderRadius.circular(5), // Rounded corners
                    border: Border.all(color: const Color(0xFF4FAE50), width: 3),
                  ),
                  padding: const EdgeInsets.all(16.0), // Padding inside the box
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                    children: [
                      // Display "The plant could not be identified" if result is "Invalid"
                      Text(
                        _result.contains('Invalid')
                            ? 'The image is Invalid.'
                            : _result.split('\n').isNotEmpty &&
                            _result.split('\n')[0].length > 15
                            ? _result.split('\n')[0].substring(
                            _result.split('\n')[0].indexOf(':') + 1)
                            .trim() // Extract predicted class
                            : '',
                        textAlign: TextAlign.center, // Center the text
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24, // Increased font size for visibility
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10), // Space between predicted class and scientific name

                      // Only display scientific name if result is not Invalid
                      if (!_result.contains('Invalid'))
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Scientific Name: ',
                                style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                              ),// Normal text
                              TextSpan(
                                text: _result.split('\n').length > 1 ? _result.split('\n')[2].trim() : '',
                                style: const TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),


                      // Only display Tagalog name if result is not Invalid
                      if (!_result.contains('Invalid'))
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Tagalog Name: ',
                                style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                              ), // Normal text
                              TextSpan(
                                text: _result.split('\n').length > 5 ? _result.split('\n')[3].trim() : '',
                              ),
                            ],
                          ),
                        ),

                      // Only display genus if result is not Invalid
                      if (!_result.contains('Invalid'))
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Genus: ',
                                style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                              ), // Normal text
                              TextSpan(
                                text: _result.split('\n').length > 4 ? _result.split('\n')[4].trim() : '',
                                style: const TextStyle(fontStyle: FontStyle.italic), // Italicized genus name
                              ),
                            ],
                          ),
                        ),


                      // Only display Species if result is not Invalid
                      if (!_result.contains('Invalid'))
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Species: ',
                                style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                              ), // Normal text
                              TextSpan(
                                text: _result.split('\n').length > 5 ? _result.split('\n')[5].trim() : '',
                                style: const TextStyle(fontStyle: FontStyle.italic), // Italicized italic name
                              ),
                            ],
                          ),
                        ),


                      if (!_result.contains('Invalid'))
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                            children: [
                              const TextSpan(
                                text: 'Family: ',
                                style: TextStyle(fontWeight: FontWeight.bold), // Bold label
                              ), // Normal text
                              TextSpan(
                                text: _result.split('\n').length > 5 ? _result.split('\n')[6].trim() : '',
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 10), // Space between Tagalog name and description

                      // Display description only if result is not Invalid
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E2E2),
                          border: Border.all(color: const Color(0xFF4FAE50), width: 3),
                          borderRadius: BorderRadius.circular(10), // Border radius
                        ),
                        padding: const EdgeInsets.all(10.0), // Padding inside the box
                        child: Text(
                          _result.isEmpty
                              ? ''
                              : _result.split('\n').length > 1
                              ? _result.split('\n')[8].trim().replaceAll('\\n', '\n') // Replace \\n with actual newlines
                              : '', // Provide an empty string if there's no value
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black, // Text color for the description
                          ),
                        ),
                      ),

                    ],
                  ),
                ),

                if (!_result.contains('Invalid')) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0), // Adds padding of 10 on top
                    child: ElevatedButton(
                      onPressed: () {
                        String predictedClass = _result.isEmpty
                            ? ''
                            : _result.split('\n').isNotEmpty && _result.split('\n')[0].length > 15
                            ? _result.split('\n')[0].substring(
                          _result.split('\n')[0].indexOf(':') + 1,
                        ).trim() // Extract predicted class
                            : '';
                        // Extract toxicityIndex from _result, assuming it's on a specific line (e.g., line 3)
                        String toxicityIndex = _result.split('\n').length > 3
                            ? _result.split('\n')[7].trim() // Adjust line number as needed
                            : '';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirstAid(predictedClass: predictedClass, toxicityIndex: toxicityIndex,),
                     // Pass the predicted class
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4fae53), // Button color
                        minimumSize: Size(boxWidth, 60), // Set width to boxWidth and height to 60
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                          side: const BorderSide(
                            color: Color(0xFF08411c),
                            width: 5, // Border color and width
                          ),
                        ),
                      ),
                      child: const Text(
                        'First Aid Guide', // Button label
                        style: TextStyle(
                          color: Color(0xFF08411c),
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                ], // If not Invalid

              ],
            ),
          ),
        ),
      ),
    );
  }









}
