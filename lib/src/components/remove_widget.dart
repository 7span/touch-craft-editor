import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';
import '../models/editable_items.dart';

/// A widget for removing an item.
///
/// This widget is a part of the UI where the user can remove an item.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a Visibility widget to display the remove button, and the user can interact with it by tapping on it.
class RemoveWidget extends StatelessWidget {
  /// Indicates whether the widget is in text input mode.
  final bool isTextInput;

  /// The active item that can be removed.
  final EditableItem? _activeItem;

  /// Indicates whether the widget is in delete position.
  final bool isDeletePosition;

  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// Creates an instance of the widget.
  ///
  /// The isTextInput, isDeletePosition, and animationsDuration parameters are required and must not be null.
  /// The activeItem parameter is optional.
  const RemoveWidget({
    super.key,
    required this.isTextInput,
    required EditableItem? activeItem,
    required this.isDeletePosition,
    required this.animationsDuration,
  }) : _activeItem = activeItem;

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !isTextInput,
      child: Positioned(
        bottom: 80 + context.bottomPadding,
        child: AnimatedSwitcher(
          duration: animationsDuration,
          child:
              _activeItem == null
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
                            color: Colors.black.withOpacity(0.5),
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
