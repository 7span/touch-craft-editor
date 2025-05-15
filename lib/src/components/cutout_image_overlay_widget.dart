import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/components/background_remover.dart';
import 'package:flutter_design_editor/src/extensions/context_extension.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// A widget that overlays the screen to preview and create a cutout sticker.
///
/// It removes the background from a selected image and allows users to confirm and create the sticker.
class CutoutImageOverlayWidget extends StatefulWidget {
  const CutoutImageOverlayWidget({
    super.key,
    required this.imagePath,
    required this.onScreenTap,
  });

  final String imagePath;
  final void Function(String? stickerPath) onScreenTap;

  @override
  State<CutoutImageOverlayWidget> createState() =>
      _CutoutImageOverlayWidgetState();
}

class _CutoutImageOverlayWidgetState extends State<CutoutImageOverlayWidget> {
  /// Indicates if the background removal process is running.
  bool isLoading = false;

  /// Holds the generated sticker image file after background removal.
  File? stickerImage;

  @override
  void initState() {
    super.initState();
    _removeBackground(widget.imagePath);
  }

  /// Handles background removal using ML model and saves result as a PNG.
  Future<void> _removeBackground(String imagePath) async {
    try {
      setState(() {
        isLoading = true;
      });
      final remover = await BackgroundRemover.loadModel();
      final result = await remover.removeBackground(File(imagePath));
      final resultBytes = img.encodePng(result);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imageFile = await _saveUint8ListToFile(
        resultBytes,
        'cropped_image_$timestamp.png',
      );
      setState(() {
        isLoading = false;
        stickerImage = imageFile;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not generate stickers')));
    }
  }

  /// Saves the cropped image bytes as a file in the temporary directory.
  Future<File> _saveUint8ListToFile(Uint8List bytes, String filename) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$filename');
    return await file.writeAsBytes(bytes);
  }

  /// Describes the part of the user interface represented by this widget.
  ///
  /// Builds the UI with a loading state and preview of generated sticker.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onScreenTap(stickerImage?.path);
      },
      child: Container(
        height: context.height,
        width: context.width,
        color: Colors.black.withValues(alpha: 0.4),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              if (isLoading)
                SizedBox(
                  width: context.width * 0.8,
                  height: context.height * 0.4,
                  child: Stack(
                    children: [
                      Center(child: Image.file(File(widget.imagePath))),
                      Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              if (stickerImage != null && !isLoading)
                SizedBox(
                  width: context.width * 0.8,
                  height: context.height * 0.4,
                  child: Image.file(stickerImage!),
                ),
              _ButtonConatainer(label: 'Create Sticker'),
            ],
          ),
        ),
      ),
    );
  }
}

/// A reusable button-style container used in the overlay.
class _ButtonConatainer extends StatelessWidget {
  const _ButtonConatainer({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(colors: [Colors.blue, Colors.green]),
      ),
      child: Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
