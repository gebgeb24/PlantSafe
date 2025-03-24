import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LoadModelScreen extends StatefulWidget {
  const LoadModelScreen({super.key});

  @override
  _LoadModelScreenState createState() => _LoadModelScreenState();
}

class _LoadModelScreenState extends State<LoadModelScreen> {
  String _loadingStatus = 'Press the button to load the model';

  Future<void> _loadModel() async {
    setState(() {
      _loadingStatus = 'Loading model...';
    });

    try {
      // Load the TFLite model from assets
      final interpreter = await Interpreter.fromAsset('assets/model/model.tflite');

      // If successful
      setState(() {
        _loadingStatus = 'Model loaded successfully!';
      });

      // Optionally, print input/output tensor details
      print("Input tensor shape: ${interpreter.getInputTensor(0).shape}");
      print("Output tensor shape: ${interpreter.getOutputTensor(0).shape}");

      // Close interpreter after use
      interpreter.close();
    } catch (e) {
      // If there's an error
      setState(() {
        _loadingStatus = 'Error loading model: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Model'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to Dashboard
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _loadingStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadModel,
              child: const Text('Load Model'),
            ),
          ],
        ),
      ),
    );
  }
}
