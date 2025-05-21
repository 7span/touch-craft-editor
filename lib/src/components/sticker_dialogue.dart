import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Colors.white,
      title: Text(
        'Create a cutout sticker',
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Select a photo with a clear subject to create sticker.',
        style: GoogleFonts.inter(color: Colors.black87, fontSize: 16),
      ),
      actions: [
        TextButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey, // your color here
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          onPressed: onCancleTap,
          child: Text(
            'Cancle',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 4),
        TextButton(
          onPressed: onOpenGalleryTap,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.amber.withAlpha(40)),
            overlayColor: WidgetStatePropertyAll(Colors.white70),
            side: WidgetStatePropertyAll(
              BorderSide(
                color: Colors.grey,
                width: 1.5,
              ), // Border color & width
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  30,
                ), // Optional: rounded corners
              ),
            ),
          ),
          child: Text(
            'Open Gallery',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
