import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/constants/enums.dart';
import 'package:flutter_design_editor/src/gif/image_view.dart';
import 'package:flutter_design_editor/src/extensions/context_extension.dart';
import 'package:flutter_design_editor/src/models/canvas_element.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget for displaying an overlay item.
///
/// This widget is a part of the UI where the user can interact with an overlay item.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a Positioned widget to display the overlay item, and the user can interact with it by tapping on it.
class OverlayItemWidget extends StatelessWidget {
  /// Creates an instance of the widget.
  ///
  /// The canvasElement and onItemTap parameters are required and must not be null.
  /// The onPointerDown, onPointerUp, and onPointerMove parameters are optional.
  const OverlayItemWidget({
    super.key,
    required this.canvasElement,
    required this.onItemTap,
    required this.backgroundColorList,
    required this.fontFamilyList,
    this.onPointerDown,
    this.onPointerUp,
    this.onPointerMove,
  });

  /// The editable item to be displayed.
  final CanvasElement canvasElement;

  /// A callback function that is called when the item is tapped.
  final VoidCallback onItemTap;

  /// A callback function that is called when a pointer has contacted the screen at a particular location.
  final Function(PointerDownEvent)? onPointerDown;

  /// A callback function that is called when a pointer has stopped contacting the screen at a particular location.
  final Function(PointerUpEvent)? onPointerUp;

  /// A callback function that is called when a pointer has moved from one location on the screen to another.
  final Function(PointerMoveEvent)? onPointerMove;

  /// The list of colors for background gradient.
  final List<List<Color>> backgroundColorList;

  /// The list of google fontfamily names for fontstyle.
  final List<String> fontFamilyList;

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    SingleChildRenderObjectWidget overlayWidget;
    switch (canvasElement.type) {
      case ItemType.text:
        overlayWidget = Center(
          child: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: backgroundColorList[canvasElement.textDecorationColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: GestureDetector(
                onTap: onItemTap,
                child: Text(
                  canvasElement.value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    fontFamilyList[canvasElement.fontFamily],
                  ).copyWith(
                    color: canvasElement.textColor,
                    fontSize: canvasElement.fontSize,
                  ),
                ),
              ),
            ),
          ),
        );
      case ItemType.image:
        overlayWidget = SizedBox(
          width: context.width * 0.8,
          height: context.height * 0.4,
          child: GestureDetector(
            onTap: onItemTap,
            child: Image.file(File(canvasElement.value)),
          ),
        );
      case ItemType.sticker:
        overlayWidget = SizedBox(
          width: context.width * 0.8,
          height: context.height * 0.4,
          child: Image.file(File(canvasElement.value)),
        );
      case ItemType.gif:
        overlayWidget = SizedBox(
          width: context.width * 0.8,
          height: context.height * 0.4,
          child: GiphyImageView(gif: canvasElement.giphyImage!),
        );
    }

    return Positioned(
      top: canvasElement.position.dy * context.height,
      left: canvasElement.position.dx * context.width,
      child: Transform.scale(
        scale: canvasElement.scale,
        child: Transform.rotate(
          angle: canvasElement.rotation,
          child: Listener(
            onPointerDown: onPointerDown,
            onPointerUp: onPointerUp,
            onPointerCancel: (details) {},
            onPointerMove: onPointerMove,
            child: overlayWidget,
          ),
        ),
      ),
    );
  }
}
