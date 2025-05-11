import 'package:flutter/material.dart';

import '../constants/item_type.dart';

/// A class representing an editable item.
///
/// An editable item can be a text or an image that can be manipulated by the user.
/// It has several properties that define its state, such as position, scale, rotation, type, value, color, textStyle, fontSize, and fontFamily.
class EditableItem {
  /// The position of the item on the screen.
  ///
  /// This is represented as an Offset, where the x and y values are the horizontal and vertical distances from the top left corner of the screen.
  Offset position = const Offset(0.1, 0.4);

  /// The scale of the item.
  ///
  /// This is a double value that represents the size of the item relative to its original size.
  double scale = 1;

  /// The rotation of the item.
  ///
  /// This is a double value that represents the rotation angle of the item in degrees.
  double rotation = 0;

  /// The type of the item.
  ///
  /// This is an enum value of type ItemType, which can be either TEXT or IMAGE.
  ItemType type = ItemType.text;

  /// The value of the item.
  ///
  /// For a text item, this is the text content. For an image item, this could be the image URL or asset path.
  String value = '';

  /// The color of the item.
  ///
  /// This is a Color value that represents the color of the item. For a text item, this is the text color.
  Color color = Colors.transparent;

  /// The style of the text.
  ///
  /// This is an integer value that represents the index of the text style in a predefined list of text styles.
  int textStyle = 0;

  /// The font size of the text.
  ///
  /// This is a double value that represents the size of the text in logical pixels.
  double fontSize = 14;

  /// The font family of the text.
  ///
  /// This is an integer value that represents the index of the font family in a predefined list of font families.
  int fontFamily = 0;
}
