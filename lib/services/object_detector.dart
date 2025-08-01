import 'package:tflite/tflite.dart';

class MobileNetService {
  static Future<void> loadModel() async {
    try {
      final result = await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/labels.txt",
      );
    } catch (e) {
      throw Exception("Error loading MobileNet model: $e");
      print("$e");
    }
  }

  static Future<String?> classify(String imagePath) async {
    try {
      final predictions = await Tflite.runModelOnImage(
        path: imagePath,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        threshold: 0.5,
      );

      if (predictions != null && predictions.isNotEmpty) {
        final label = predictions.first['label'] as String;
        return label.replaceAll(RegExp(r'^\d+:\s*'), '').trim(); // clean "0: label"
      }
      return null;
    } catch (e) {
      throw Exception("Classification failed: $e");
    }
  }

  static Future<void> dispose() async {
    await Tflite.close();
  }
}
