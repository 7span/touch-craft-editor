import 'package:flutter/material.dart';

/// convert Color value to Hex-String.
///
/// This method is used to conver Color value to Hex String to use in toJson.
String colorToHex(Color color) {
  return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

/// convert Hex-String to Color value.
///
/// This method is used to conver Hex String to  Color value to use in fromJson.
Color hexToColor(String hexValue) {
  final hex = hexValue.replaceAll('#', '');
  final intColor = int.parse(hex, radix: 16);
  return Color.fromARGB(
    (intColor >> 24) & 0xFF, // alpha
    (intColor >> 16) & 0xFF, // red
    (intColor >> 8) & 0xFF, // green
    intColor & 0xFF, // blue
  );
}
