import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/constants/font_styles.dart';
import 'package:flutter_design_editor/src/constants/gradients.dart';
import 'package:flutter_design_editor/src/extensions/context_extension.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget for displaying a text field.
///
/// This widget is a part of the UI where the user can interact with a text field.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a TextField widget to display the text field, and the user can interact with it by typing into it.
class TextFieldWidget extends StatelessWidget {
  /// The controller for the TextField.
  final TextEditingController controller;

  /// A callback function that is called when the text field value changes.
  final Function(String val) onChanged;

  /// A callback function that is called when the user submits the text field.
  final Function(String val) onSubmit;

  /// The font size of the text in the text field.
  final double fontSize;

  /// The index of the font family to be used in the text field.
  final int fontFamilyIndex;

  /// The color of the text in the text field.
  final Color textColor;

  /// The index of the background color to be used in the text field.
  final int backgroundColorIndex;

  /// Creates an instance of the widget.
  ///
  /// All parameters are required and must not be null.
  const TextFieldWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
    required this.fontSize,
    required this.fontFamilyIndex,
    required this.textColor,
    required this.backgroundColorIndex,
  });

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 36,
      top: 0,
      bottom: 96,
      child: Center(
        child: Container(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: 100,
            maxWidth: context.width - 72,
          ),
          child: Center(
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors[backgroundColorIndex],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  autofocus: true,
                  controller: controller,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    fontFamilyList[fontFamilyIndex],
                  ).copyWith(color: textColor, fontSize: fontSize),
                  cursorColor: textColor,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    fillColor: Colors.transparent,
                    filled: false,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  onChanged: onChanged,
                  onSubmitted: onSubmit,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
