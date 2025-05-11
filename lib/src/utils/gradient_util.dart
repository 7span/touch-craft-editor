import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Creates a linear gradient shader.
///
/// The shader is created using the provided colors, width, and height.
/// The gradient starts from the top left and ends at the center right.
///
/// The [colors] parameter is a list of colors that define the gradient.
/// The [width] and [height] parameters define the size of the area covered by the gradient.
///
/// Returns a [ui.Shader] that can be used to paint a [Canvas].
ui.Shader createShader({
  required List<Color> colors,
  required double width,
  required double height,
}) {
  return LinearGradient(
    begin: FractionalOffset.topLeft,
    end: FractionalOffset.centerRight,
    colors: colors,
  ).createShader(
    Rect.fromLTWH(
      0,
      0,
      width,
      height,
    ),
  );
}
