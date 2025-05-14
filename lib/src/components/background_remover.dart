import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class BackgroundRemover {
  final Interpreter _interpreter;

  BackgroundRemover._(this._interpreter);

  static Future<BackgroundRemover> loadModel() async {
    final interpreter = await Interpreter.fromAsset(
      'assets/models/deeplabv3_257_mv_gpu.tflite',
    );
    return BackgroundRemover._(interpreter);
  }

  Future<img.Image> removeBackground(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image original = img.decodeImage(bytes)!;

    // Resize to model input size (257x257)
    img.Image inputImage = img.copyResize(original, width: 257, height: 257);

    // Create input tensor: [1, 257, 257, 3]
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

    // Prepare output: [1, 257, 257, 21]
    final output = List.generate(
      1,
      (_) => List.generate(
        257,
        (_) => List.generate(257, (_) => List.filled(21, 0.0)),
      ),
    );

    _interpreter.run(input, output);

    // First get the argmax class for each pixel
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

    // Check if class 15 is being detected at all
    bool hasPersonClass = false;
    for (int y = 0; y < 257 && !hasPersonClass; y++) {
      for (int x = 0; x < 257 && !hasPersonClass; x++) {
        if (classMap[y][x] == 15) {
          hasPersonClass = true;
          break;
        }
      }
    }

    // If no person class detected, try a different class index
    // DeepLabV3 models often use class 0 for background and 15 for person,
    // but other models might use different indices
    final personClassIndex =
        hasPersonClass ? 15 : 1; // Try class 1 if 15 isn't found

    // Create output image with transparent background
    img.Image result = img.Image(
      width: original.width,
      height: original.height,
      numChannels: 4, // RGBA (with alpha channel for transparency)
    );

    // Create binary mask with slightly improved edges
    for (int y = 0; y < result.height; y++) {
      for (int x = 0; x < result.width; x++) {
        // Map the coordinates from original image to mask
        int mx = (x * 257 / result.width).floor();
        int my = (y * 257 / result.height).floor();
        mx = mx.clamp(0, 256);
        my = my.clamp(0, 256);

        // Count neighboring pixels to smooth edges a bit
        int personPixelsCount = 0;
        int totalChecked = 0;

        // Check a small window around the pixel for edge smoothing
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

        // Use a ratio for soft edges
        double ratio = personPixelsCount / totalChecked;
        int alpha = (ratio * 255).round().clamp(0, 255);

        // Apply a threshold to keep definite foreground fully opaque
        if (ratio > 0.6) alpha = 255;
        if (ratio < 0.2) alpha = 0;

        // Apply the alpha
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
