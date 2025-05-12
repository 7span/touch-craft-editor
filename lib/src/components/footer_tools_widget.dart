import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extension.dart';

/// A widget for displaying footer tools.
///
/// This widget is a part of the UI where the user can interact with footer tools.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses an ElevatedButton to display a done button, and the user can interact with it by tapping on it.
class FooterToolsWidget extends StatelessWidget {
  /// A callback function that is called when the done button is pressed.
  final AsyncCallback onDone;

  /// The child widget of the done button.
  final Widget? doneButtonChild;

  /// Indicates whether the widget is in loading state.
  final bool isLoading;

  /// Creates an instance of the widget.
  ///
  /// The onDone parameter is required and must not be null.
  /// The doneButtonChild and isLoading parameters are optional.
  const FooterToolsWidget({
    super.key,
    required this.onDone,
    this.doneButtonChild,
    this.isLoading = false,
  });

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.bottomPadding + kToolbarHeight,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: onDone,
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                ),
                shadowColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
              child:
                  isLoading
                      ? const CupertinoActivityIndicator()
                      : doneButtonChild ??
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 4),
                                  Text(
                                    'Done',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    CupertinoIcons.forward,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
            ),
          ],
        ),
      ),
    );
  }
}
