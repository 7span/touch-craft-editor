import 'dart:io';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/extensions/context_extension.dart';

class ImageCropView extends StatelessWidget {
  const ImageCropView({
    required this.imageValue,
    required this.cropController,
    super.key,
  });

  final String imageValue;
  final CropController cropController;

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
