import 'package:flutter/material.dart';
import 'package:touch_craft_editor/src/extensions/context_extension.dart';
import 'package:touch_craft_editor/src/models/canvas_element.dart';

/// A widget for removing an item.
///
/// This widget is a part of the UI where the user can remove an item.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a Visibility widget to display the remove button, and the user can interact with it by tapping on it.
class RemoveWidget extends StatelessWidget {
  /// Creates an instance of the widget.
  ///
  /// The isTextInput, isDeletePosition, and animationsDuration parameters are required and must not be null.
  /// The activeItem parameter is optional.
  const RemoveWidget({
    super.key,
    required CanvasElement? activeItem,
    required shouldShowDeleteButton,
    required this.isDeletePosition,
    required this.animationsDuration,
  })  : _activeItem = activeItem,
        _shouldShowDeleteButton = shouldShowDeleteButton;

  /// The active item that can be removed.
  final CanvasElement? _activeItem;

  /// Indicates whether the widget is in delete position.
  final bool isDeletePosition;

  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// Indicates whether the remove button should be shown.
  final bool _shouldShowDeleteButton;

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _shouldShowDeleteButton,
      child: Positioned(
        bottom: 80 + context.bottomPadding,
        child: AnimatedSwitcher(
          duration: animationsDuration,
          child: _activeItem == null
              ? const SizedBox()
              : AnimatedSize(
                  duration: animationsDuration,
                  child: SizedBox(
                    width: context.width,
                    child: Center(
                      child: AnimatedContainer(
                        duration: animationsDuration,
                        height: !isDeletePosition ? 60.0 : 72,
                        width: !isDeletePosition ? 60.0 : 72,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.all(
                            Radius.circular(!isDeletePosition ? 30 : 38),
                          ),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
