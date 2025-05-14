import 'package:flutter/material.dart';

/// A widget that displays an alert dialog for sticker creation.
///
/// This dialog prompts the user to pick an image to create a cutout sticker.
/// It offers two options: cancel or open the image gallery.
class StickerDialogue extends StatelessWidget {
  /// Creates a [StickerDialogue] widget.
  ///
  /// Requires [onCancleTap] and [onOpenGalleryTap] to handle user actions.
  const StickerDialogue({
    required this.onCancleTap,
    required this.onOpenGalleryTap,
    super.key,
  });

  /// Callback triggered when the cancel button is tapped.
  final VoidCallback onCancleTap;

  /// Callback triggered when the open gallery button is tapped.
  final VoidCallback onOpenGalleryTap;

  /// Describes the part of the user interface represented by this widget.
  ///
  /// Builds the alert dialog with title, content, and action buttons.
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black54,
      title: Text(
        'Create a cutout sticker',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      content: Text(
        'Select a photo with a clear subject',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: onCancleTap,
          child: Text(
            'Cancle',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: onOpenGalleryTap,
          child: Text(
            'Open Gallery',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
