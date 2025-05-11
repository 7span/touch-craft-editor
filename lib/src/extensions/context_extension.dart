import 'package:flutter/material.dart';

/// Extension on [BuildContext] to add additional properties and methods.
extension BuildContextExtensions on BuildContext {
  /// Get the [ThemeData] from the current [BuildContext].
  ThemeData get theme => Theme.of(this);

  /// Get the [MediaQueryData] from the current [BuildContext].
  MediaQueryData get media => MediaQuery.of(this);

  /// Get the height of the screen from the current [BuildContext].
  double get height => media.size.height;

  /// Get the width of the screen from the current [BuildContext].
  double get width => media.size.width;

  /// Get the top padding of the screen from the current [BuildContext].
  double get topPadding => media.padding.top;

  /// Get the bottom padding of the screen from the current [BuildContext].
  double get bottomPadding => media.padding.bottom;
}
