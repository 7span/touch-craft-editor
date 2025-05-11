import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/gradients.dart';
import '../extensions/context_extension.dart';
import '../models/editable_items.dart';

/// A widget for displaying the top tools.
///
/// This widget is a part of the UI where the user can interact with the top tools.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a Positioned widget to display the top tools, and the user can interact with it by tapping on it.
class TopToolsWidget extends StatelessWidget {
  /// Indicates whether the widget is in text input mode.
  final bool isTextInput;

  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// The active item that can be interacted with.
  final EditableItem? activeItem;

  /// The index of the currently selected background gradient.
  final int selectedBackgroundGradientIndex;

  /// The index of the currently selected text background gradient.
  final int selectedTextBackgroundGradientIndex;

  /// A callback function that is called when the screen is tapped.
  final VoidCallback onScreenTap;

  /// A callback function that is called when the picker is tapped.
  final VoidCallback onPickerTap;

  /// A callback function that is called when the text color picker is toggled.
  final VoidCallback onToggleTextColorPicker;

  /// A callback function that is called when the text background is changed.
  final VoidCallback onChangeTextBackground;

  /// Creates an instance of the widget.
  ///
  /// All parameters are required and must not be null.
  const TopToolsWidget({
    super.key,
    required this.isTextInput,
    required this.animationsDuration,
    this.selectedBackgroundGradientIndex = 0,
    this.selectedTextBackgroundGradientIndex = 0,
    required this.onScreenTap,
    required this.onPickerTap,
    required this.onToggleTextColorPicker,
    required this.onChangeTextBackground,
    this.activeItem,
  });

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    if (isTextInput) {
      return Positioned(
        top: context.topPadding,
        child: Container(
          width: context.width,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.color_lens_outlined,
                  color: Colors.white,
                ),
                onPressed: onToggleTextColorPicker,
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors:
                          gradientColors[selectedTextBackgroundGradientIndex],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
                onPressed: onChangeTextBackground,
              ),
            ],
          ),
        ),
      );
    }

    return Positioned(
      top: context.topPadding + 12,
      right: 20,
      left: 20,
      child: AnimatedSwitcher(
        duration: animationsDuration,
        child:
            activeItem != null
                ? const SizedBox()
                : Row(
                  children: [
                    const BackButton(color: Colors.white),
                    const Spacer(),
                    GestureDetector(
                      onTap: onPickerTap,
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                gradientColors[selectedBackgroundGradientIndex],
                          ),
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onScreenTap,
                      child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Center(
                          child: Text(
                            'Aa',
                            style: GoogleFonts.ubuntu(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
