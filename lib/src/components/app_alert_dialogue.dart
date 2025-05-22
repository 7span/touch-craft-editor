import 'package:flutter/material.dart';
import 'package:touch_craft_editor/src/constants/primary_color.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget that displays an alert dialog for sticker creation.
///
/// This dialog prompts the user to pick an image to create a cutout sticker.
/// It offers two options: cancel or open the image gallery.
class AppAlertDialogue extends StatelessWidget {
  /// Creates a [StickerDialogue] widget.
  ///
  /// Requires [onCancleTap] and [onContinueTap] to handle user actions.
  const AppAlertDialogue({
    required this.onContinueTap,
    required this.title,
    required this.description,
    required this.continueButtonTitle,
    required this.shouldShowCancelButton,
    this.cancelButtonTitle,
    this.onCancleTap,
    super.key,
  });

  /// Callback triggered when the cancel button is tapped.
  final VoidCallback? onCancleTap;

  /// Callback triggered when the open gallery button is tapped.
  final VoidCallback onContinueTap;

  // content, description, cancel and continue button title for dialogue.
  final String title;
  final String description;
  final String continueButtonTitle;
  final String? cancelButtonTitle;

  // to show hide cancel button
  final bool shouldShowCancelButton;

  /// Describes the part of the user interface represented by this widget.
  ///
  /// Builds the alert dialog with title, content, and action buttons.
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        description,
        style: GoogleFonts.inter(color: Colors.black87, fontSize: 16),
      ),
      actions: [
        if (shouldShowCancelButton) ...[
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
              cancelButtonTitle ?? '',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 4),
        ],
        TextButton(
          onPressed: onContinueTap,
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(primaryThemeColor),
            overlayColor: WidgetStatePropertyAll(Colors.white70),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  30,
                ), // Optional: rounded corners
              ),
            ),
          ),
          child: Text(
            continueButtonTitle,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
