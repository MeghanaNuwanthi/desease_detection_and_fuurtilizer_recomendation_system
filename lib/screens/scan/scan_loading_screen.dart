import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/disease_classifier_service.dart';
import '../scan_result/scan_result_screen.dart';

class ScanLoadingScreen extends StatefulWidget {

  final String imagePath;

  const ScanLoadingScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<ScanLoadingScreen> createState() => _ScanLoadingScreenState();
}

class _ScanLoadingScreenState extends State<ScanLoadingScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;

  // Must match the "not_leaf" folder name used in train_disease_model.py -
  // the model now explicitly learns to recognize non-leaf images, rather
  // than relying purely on a confidence guess.
  static const String _notLeafLabel = "not_leaf";

  // Kept as a secondary safeguard even with a trained not_leaf class - a
  // low-confidence "paddy_blast" guess is still worth flagging as unsure,
  // not just outright wrong not_leaf predictions.
  static const double _confidenceThreshold = 0.65;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0, end: 200).animate(controller);

    _runClassification();
  }

  Future<void> _runClassification() async {
    try {
      await DiseaseClassifierService.instance.load();

      final prediction =
          await DiseaseClassifierService.instance.classify(widget.imagePath);

      if (!mounted) return;

      final isNotLeaf = prediction.label == _notLeafLabel;
      final isLowConfidence = prediction.confidence < _confidenceThreshold;

      if (isNotLeaf || isLowConfidence) {
        _showUnrecognizedDialog();
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScanResultScreen(
            imagePath: widget.imagePath,
            diseaseKey: prediction.label,
            confidencePercent: prediction.confidencePercent,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not analyze image: $e")),
      );
    }
  }

  void _showUnrecognizedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Couldn't identify a paddy leaf"),
        content: const Text(
          "This photo doesn't look like a paddy leaf, or it's too unclear "
          "for the model to be confident. Try taking a closer, well-lit "
          "photo of a single leaf against a plain background.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to home/scan entry point
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [

            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(widget.imagePath),
                width: 260,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),

            /// Scanning Line
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {

                return Positioned(
                  top: animation.value,
                  child: Container(
                    width: 260,
                    height: 3,
                    color: Colors.greenAccent,
                  ),
                );
              },
            ),

            /// Text
            Positioned(
              bottom: -80,
              child: Column(
                children: const [

                  CircularProgressIndicator(
                    color: Colors.green,
                  ),

                  SizedBox(height: 15),

                  Text(
                    "AI is analyzing the crop...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
