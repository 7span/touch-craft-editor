import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/extensions/context_extension.dart';

/// A widget for selecting a background gradient.
///
/// This widget is a part of the UI where the user can select a gradient to be used as a background.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a PageView.builder to display a list of available gradients, and the user can select one by tapping on it.
class BackgroundGradientSelectorWidget extends StatelessWidget {
  /// Indicates whether the widget is in text input mode.
  final bool isTextInput;

  /// Indicates whether the background color picker is selected.
  final bool isBackgroundColorPickerSelected;

  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// A callback function that is called when the page changes.
  final Function(int item) onPageChanged;

  /// A callback function that is called when an item is tapped.
  final Function(int item) onItemTap;

  /// Indicates whether the widget is in action.
  final bool inAction;

  /// The controller for the PageView of gradients.
  final PageController gradientsPageController;

  /// The index of the currently selected gradient.
  final int selectedGradientIndex;

  /// Determines whether the widget is visible.
  ///
  /// The widget is visible if the background color picker is selected, and the widget is not in text input mode or in action.
  bool get isVisible =>
      isBackgroundColorPickerSelected && !isTextInput && !inAction;

  /// The list of colors for background gradients.
  final List<List<Color>> backgroundColorList;

  /// Creates an instance of the widget.
  ///
  /// All parameters are required and must not be null.
  const BackgroundGradientSelectorWidget({
    super.key,
    required this.isTextInput,
    required this.isBackgroundColorPickerSelected,
    required this.inAction,
    required this.animationsDuration,
    required this.gradientsPageController,
    required this.onPageChanged,
    required this.onItemTap,
    required this.selectedGradientIndex,
    required this.backgroundColorList,
  });

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: AnimatedPositioned(
        duration: animationsDuration,
        bottom: 80 + context.bottomPadding,
        right: 0,
        left: 0,
        child: Container(
          height: context.width * .175,
          width: context.width,
          alignment: Alignment.center,
          child: PageView.builder(
            controller: gradientsPageController,
            itemCount: backgroundColorList.length,
            onPageChanged: onPageChanged,
            physics: const BouncingScrollPhysics(),
            allowImplicitScrolling: true,
            pageSnapping: false,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onItemTap(index),
                child: Container(
                  height: context.width * .175,
                  width: context.width * .175,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.centerRight,
                      colors: backgroundColorList[index],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(context.width * .175),
                    ),
                    border: Border.all(color: Colors.white),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: animationsDuration,
                      child:
                          index == selectedGradientIndex
                              ? Icon(
                                CupertinoIcons.checkmark_alt,
                                color:
                                    selectedGradientIndex == 0
                                        ? Colors.white
                                        : backgroundColorList[selectedGradientIndex]
                                                .last
                                                .computeLuminance() >
                                            0.5
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
      ),
    );
  }
}
