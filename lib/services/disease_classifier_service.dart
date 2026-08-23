import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class DiseasePrediction {
  final String label;
  final double confidence; // 0.0 - 1.0

  DiseasePrediction({required this.label, required this.confidence});

  /// Confidence as a whole-number percentage string, e.g. "92%"
  String get confidencePercent => "${(confidence * 100).round()}%";
}

class DiseaseClassifierService {
  DiseaseClassifierService._internal();
  static final DiseaseClassifierService instance =
      DiseaseClassifierService._internal();

  static const String _modelPath = "assets/models/disease_model.tflite";
  static const String _labelsPath = "assets/models/labels.txt";
  static const int _inputSize = 224; // must match IMG_SIZE in training script

  Interpreter? _interpreter;
  List<String> _labels = [];
  bool get isLoaded => _interpreter != null;

  Future<void> load() async {
    if (_interpreter != null) return; // already loaded

    _interpreter = await Interpreter.fromAsset(_modelPath);

    final labelsRaw = await rootBundle.loadString(_labelsPath);
    _labels = labelsRaw
        .split("\n")
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  /// Runs inference on the image at [imagePath]. Call [load] first, or this
  /// will throw a StateError.
  Future<DiseasePrediction> classify(String imagePath) async {
    if (_interpreter == null) {
      throw StateError(
        "DiseaseClassifierService.load() must be called before classify().",
      );
    }

    final rawBytes = await File(imagePath).readAsBytes();
    final decoded = img.decodeImage(rawBytes);
    if (decoded == null) {
      throw Exception("Could not decode image at $imagePath");
    }

    final resized = img.copyResize(
      decoded,
      width: _inputSize,
      height: _inputSize,
    );

    // Build normalized [1, 224, 224, 3] input, values scaled 0-1 to match
    // the `rescale=1.0/255` used in ImageDataGenerator during training.
    final input = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(_inputSize, (x) {
          final pixel = resized.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    );

    final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    _interpreter!.run(input, output);

    final scores = output[0];
    var bestIndex = 0;
    var bestScore = scores[0];

    for (var i = 1; i < scores.length; i++) {
      if (scores[i] > bestScore) {
        bestScore = scores[i];
        bestIndex = i;
      }
    }

    return DiseasePrediction(
      label: _labels[bestIndex],
      confidence: bestScore.clamp(0.0, 1.0),
    );
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
