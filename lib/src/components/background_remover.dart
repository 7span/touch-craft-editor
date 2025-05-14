import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// A utility class to remove background from an image using DeepLabV3 model.
///
/// Loads and runs a TensorFlow Lite model to segment the subject
/// and apply transparency to the background.
class BackgroundRemover {
  /// Interpreter for the TFLite DeepLabV3 model.
  final Interpreter _interpreter;

  /// Private constructor.
  BackgroundRemover._(this._interpreter);

  /// Loads the TFLite model from assets.
  ///
  /// Returns an instance of [BackgroundRemover] with loaded interpreter.
  static Future<BackgroundRemover> loadModel() async {
    final interpreter = await Interpreter.fromAsset(
      'assets/models/deeplabv3_257_mv_gpu.tflite',
    );
    return BackgroundRemover._(interpreter);
  }

  /// Removes background from the provided [imageFile].
  ///
  /// Returns a transparent [img.Image] with only the subject visible.
  Future<img.Image> removeBackground(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image original = img.decodeImage(bytes)!;

    // Resize input image to model's expected size (257x257)
    img.Image inputImage = img.copyResize(original, width: 257, height: 257);

    // Create input tensor of shape [1, 257, 257, 3] with normalized RGB values
    final input = List.generate(
      1,
      (_) => List.generate(
        257,
        (y) => List.generate(257, (x) {
          final pixel = inputImage.getPixel(x, y);
          return [
            (pixel.r / 127.5) - 1.0,
            (pixel.g / 127.5) - 1.0,
            (pixel.b / 127.5) - 1.0,
          ];
        }),
      ),
    );

    // Output tensor shape: [1, 257, 257, 21] — 21 classes
    final output = List.generate(
      1,
      (_) => List.generate(
        257,
        (_) => List.generate(257, (_) => List.filled(21, 0.0)),
      ),
    );

    // Run model inference
    _interpreter.run(input, output);

    // Generate class map with highest scoring label (argmax) per pixel
    final classMap = List.generate(257, (y) {
      return List.generate(257, (x) {
        final scores = output[0][y][x];
        int maxIndex = 0;
        double maxValue = scores[0];

        for (int i = 1; i < scores.length; i++) {
          if (scores[i] > maxValue) {
            maxValue = scores[i];
            maxIndex = i;
          }
        }

        return maxIndex;
      });
    });

    // Check if class 15 (person) is detected
    bool hasPersonClass = false;
    for (int y = 0; y < 257 && !hasPersonClass; y++) {
      for (int x = 0; x < 257 && !hasPersonClass; x++) {
        if (classMap[y][x] == 15) {
          hasPersonClass = true;
          break;
        }
      }
    }

    // Fallback to class 1 if class 15 not found
    final personClassIndex = hasPersonClass ? 15 : 1;

    // Initialize final output image with alpha channel
    img.Image result = img.Image(
      width: original.width,
      height: original.height,
      numChannels: 4,
    );

    // Generate soft-edged binary mask and apply transparency
    for (int y = 0; y < result.height; y++) {
      for (int x = 0; x < result.width; x++) {
        // Map pixel coordinates to mask dimensions
        int mx = (x * 257 / result.width).floor();
        int my = (y * 257 / result.height).floor();
        mx = mx.clamp(0, 256);
        my = my.clamp(0, 256);

        // Count neighboring person pixels for edge smoothing
        int personPixelsCount = 0;
        int totalChecked = 0;

        for (int offsetY = -1; offsetY <= 1; offsetY++) {
          for (int offsetX = -1; offsetX <= 1; offsetX++) {
            int checkX = mx + offsetX;
            int checkY = my + offsetY;

            if (checkX >= 0 && checkX < 257 && checkY >= 0 && checkY < 257) {
              totalChecked++;
              if (classMap[checkY][checkX] == personClassIndex) {
                personPixelsCount++;
              }
            }
          }
        }

        final origPixel = original.getPixel(x, y);

        // Calculate alpha value based on neighborhood match ratio
        double ratio = personPixelsCount / totalChecked;
        int alpha = (ratio * 255).round().clamp(0, 255);

        // Apply thresholds for hard mask edges
        if (ratio > 0.6) alpha = 255;
        if (ratio < 0.2) alpha = 0;

        // Write pixel with computed alpha
        if (classMap[my][mx] == personClassIndex || alpha > 10) {
          result.setPixelRgba(
            x,
            y,
            origPixel.r,
            origPixel.g,
            origPixel.b,
            alpha,
          );
        } else {
          result.setPixelRgba(x, y, 0, 0, 0, 0);
        }
      }
    }

    return result;
  }
}
