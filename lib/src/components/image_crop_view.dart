import 'dart:io';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:touch_craft_editor/src/extensions/context_extension.dart';

/// A widget that displays an image crop view.
///
/// This widget allows users to crop a selected image using a visible grid overlay.
/// It uses the `CropImage` package and supports third-line grid and free movement.
class ImageCropView extends StatelessWidget {
  /// Creates an [ImageCropView] widget.
  ///
  /// Requires the [imageValue] for displaying the image and [cropController] to manage the cropping.
  const ImageCropView({
    required this.imageValue,
    required this.cropController,
    super.key,
  });

  /// The file path of the image to crop.
  final String imageValue;

  /// Controller for managing the crop actions.
  final CropController cropController;

  /// Describes the part of the user interface represented by this widget.
  ///
  /// Builds the full-screen crop view layout with center alignment.
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height,
      width: context.width,
      color: Colors.black.withValues(alpha: 0.4),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: context.height / 1.5,
              width: context.width / 1.5,
              child: CropImage(
                controller: cropController,
                alwaysShowThirdLines: true,
                gridCornerColor: Colors.amberAccent,
                alwaysMove: true,
                image: Image.file(File(imageValue)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
