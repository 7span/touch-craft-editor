import 'package:enough_giphy/enough_giphy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/constants/enums.dart';
import 'package:flutter_design_editor/src/extensions/helpers.dart';

/// A class representing an editable item.
///
/// An editable item can be a text or an image that can be manipulated by the user.
/// It has several properties that define its state, such as position, scale, rotation, type, value, color, textStyle, fontSize, and fontFamily.
class CanvasElement {
  CanvasElement();

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
  Color textColor = Colors.transparent;

  /// The style of the text.
  ///
  /// This is an integer value that represents the index of the text style in a predefined list of text styles.
  int textDecorationColor = 0;

  /// The font size of the text.
  ///
  /// This is a double value that represents the size of the text in logical pixels.
  double fontSize = 14;

  /// The font family of the text.
  ///
  /// This is an integer value that represents the index of the font family in a predefined list of font families.
  int fontFamily = 0;

  /// The giphyImage for GIF.
  ///
  /// This is an GiphyGif value that represents the GIF value.
  GiphyGif? giphyImage;

  /// Returns information about all widgets in design.
  ///
  /// This methos returns config for all the CanvasElement used to return design json on image/GIF creation.
  Map<String, dynamic> toJson({
    required String fontFamilyValue,
    required List<Color> fontBackgroundColorValue,
  }) => {
    "position": {"x": position.dx, "y": position.dy},
    "scale": scale,
    "rotation": rotation,
    "type": type.name,
    "value": value,
    "textColor": textColor,
    "fontDecorationColor": fontBackgroundColorValue,
    "fontSize": fontSize,
    "fontFamily": fontFamilyValue,
    "giphyImage": giphyImage?.toJson(),
  };

  factory CanvasElement.fromJson({
    required Map<String, dynamic> json,
    required List<String> fontFamilyList,
    required List<List<Color>> textDecorationColorList,
  }) {
    final colorList =
        json['textDecorationColor'] != null
            ? json['textDecorationColor'] as List<String>
            : [];
    final int textDecorationColorIndex = textDecorationColorList.indexWhere(
      (element) => element == colorList,
    );
    return CanvasElement()
      ..value = (json['value'] as String?) ?? ''
      ..type =
          json['type'] != null
              ? stringToItemType(json['type'] as String)
              : ItemType.text
      ..scale = json['scale'] != null ? json['scale'] as double : 1
      ..rotation = json['rotation'] != null ? json['rotation'] as double : 0
      ..fontSize = json['fontSize'] != null ? json['fontSize'] as double : 14
      ..position =
          json['position'] != null
              ? Offset(
                json['position']['x'] as double,
                json['position']['y'] as double,
              )
              : Offset(0.1, 0.4)
      ..fontFamily =
          json['fontFamily'] != null
              ? fontFamilyList.indexWhere(
                (element) => element == (json['fontFamily'] as String),
              )
              : 0
      ..giphyImage =
          json['giphyImage'] != null
              ? GiphyGif.fromJson(json['giphyImage'] as Map<String, dynamic>)
              : null
      ..textColor = json['textColor'] ?? Colors.transparent
      ..textDecorationColor =
          textDecorationColorIndex != -1 ? textDecorationColorIndex : 0;
  }
}
