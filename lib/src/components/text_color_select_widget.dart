import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/extensions/context_extension.dart';

/// A widget for selecting a text color.
///
/// This widget is a part of the UI where the user can select a text color to be used in the application.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a PageView.builder to display a list of available text colors, and the user can select one by tapping on it.
class TextColorSelectWidget extends StatelessWidget {
  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// The controller for the PageView of text colors.
  final PageController pageController;

  /// The currently selected text color.
  final Color selectedTextColor;

  /// A callback function that is called when the page changes.
  final Function(int index) onPageChanged;

  /// A callback function that is called when an item is tapped.
  final Function(int index) onTap;

  final List<Color> fontColorList;

  /// Creates an instance of the widget.
  ///
  /// All parameters are required and must not be null.
  const TextColorSelectWidget({
    super.key,
    required this.animationsDuration,
    required this.pageController,
    required this.selectedTextColor,
    required this.onPageChanged,
    required this.onTap,
    required this.fontColorList,
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
        height: 28,
        width: context.width,
        alignment: Alignment.center,
        child: PageView.builder(
          controller: pageController,
          itemCount: fontColorList.length,
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
                height: 28,
                width: 28,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: fontColorList[index],
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: animationsDuration,
                    child:
                        fontColorList[index] == selectedTextColor
                            ? Icon(
                              CupertinoIcons.checkmark_alt,
                              color:
                                  selectedTextColor == Colors.white
                                      ? Colors.black
                                      : Colors.white,
                            )
                            : const SizedBox(),
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
