import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class ObjectLabelerService {
  final ImageLabeler _labeler;

  ObjectLabelerService()
      : _labeler = ImageLabeler(
          options: ImageLabelerOptions(confidenceThreshold: 0.6),
        );

  /// Takes a [filePath] and returns the most probable label or null.
  Future<String?> classify(String filePath) async {
    final imageFile = File(filePath);
    if (!imageFile.existsSync()) return null;

    final inputImage = InputImage.fromFile(imageFile);
    final labels = await _labeler.processImage(inputImage);

    if (labels.isEmpty) return null;

    // Sort labels by confidence (highest first)
    labels.sort((a, b) => b.confidence.compareTo(a.confidence));

    return labels.first.label;
  }

  /// Call this to release resources
  void dispose() {
    _labeler.close();
  }
}
