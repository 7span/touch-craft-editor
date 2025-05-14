import 'package:flutter/material.dart';

class StickerDialogue extends StatelessWidget {
  const StickerDialogue({
    required this.onCancleTap,
    required this.onOpenGalleryTap,
    super.key,
  });

  final VoidCallback onCancleTap;
  final VoidCallback onOpenGalleryTap;

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
