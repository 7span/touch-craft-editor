import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';

/// A widget for controlling the size of an item.
///
/// This widget is a part of the UI where the user can control the size of an item.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a Slider widget to display the size control, and the user can interact with it by sliding it.
class SizeSliderWidget extends StatelessWidget {
  /// Creates an instance of the widget.
  ///
  /// The animationsDuration, onChanged, and selectedValue parameters are required and must not be null.
  const SizeSliderWidget({
    super.key,
    required this.animationsDuration,
    required this.onChanged,
    required this.selectedValue,
  });

  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// The currently selected value of the slider.
  final double selectedValue;

  /// A callback function that is called when the slider value changes.
  final Function(double value) onChanged;

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: animationsDuration,
      top: context.height * .5 - 162,
      left: -100,
      child: Transform(
        alignment: FractionalOffset.center,
        // Rotate sliders by 90 degrees
        transform: Matrix4.identity()..rotateZ(270 * 3.1415927 / 180),
        child: SizedBox(
          width: 248,
          child: Slider(
            value: selectedValue,
            min: 14,
            max: 74,
            thumbColor: Colors.white60,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withValues(alpha: 0.4),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
