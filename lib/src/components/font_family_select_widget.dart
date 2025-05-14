import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/constants/font_styles.dart';
import 'package:flutter_design_editor/src/extensions/context_extension.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget for selecting a font family.
///
/// This widget is a part of the UI where the user can select a font family to be used in the application.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a PageView.builder to display a list of available font families, and the user can select one by tapping on it.
class FontFamilySelectWidget extends StatelessWidget {
  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// The controller for the PageView of font families.
  final PageController pageController;

  /// The index of the currently selected font family.
  final int selectedFamilyIndex;

  /// A callback function that is called when the page changes.
  final Function(int index) onPageChanged;

  /// A callback function that is called when an item is tapped.
  final Function(int index) onTap;

  /// Creates an instance of the widget.
  ///
  /// All parameters are required and must not be null.
  const FontFamilySelectWidget({
    super.key,
    required this.animationsDuration,
    required this.pageController,
    required this.selectedFamilyIndex,
    required this.onPageChanged,
    required this.onTap,
  });

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: animationsDuration,
      bottom: context.media.viewInsets.bottom + 8,
      right: 0,
      left: 0,
      child: Container(
        height: context.width * .1,
        width: context.width,
        alignment: Alignment.center,
        child: PageView.builder(
          controller: pageController,
          itemCount: googleFontFamilyList.length,
          onPageChanged: onPageChanged,
          physics: const BouncingScrollPhysics(),
          allowImplicitScrolling: true,
          pageSnapping: false,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                onTap(index);
              },
              child: Container(
                height: context.width * .1,
                width: context.width * .1,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color:
                      index == selectedFamilyIndex
                          ? Colors.white
                          : Colors.black.withValues(alpha: 0.4),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    'Aa',
                    style: GoogleFonts.getFont(
                      googleFontFamilyList[index],
                    ).copyWith(
                      color:
                          index == selectedFamilyIndex
                              ? Colors.red
                              : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
