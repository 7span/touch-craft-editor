import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/constants/item_type.dart';
import 'package:flutter_design_editor/src/extensions/context_extension.dart';
import 'package:flutter_design_editor/src/models/editable_items.dart';
import 'package:google_fonts/google_fonts.dart';

/// A widget for displaying the top tools.
///
/// This widget is a part of the UI where the user can interact with the top tools.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a Positioned widget to display the top tools, and the user can interact with it by tapping on it.
class TopToolsWidget extends StatelessWidget {
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

  /// To select image from gallery
  final VoidCallback onImagePickerTap;

  /// A callback function that is called when the crop button is tapped.
  final VoidCallback onCropTap;

  /// A callback function that is called when the add Giphy button is tapped
  final VoidCallback onAddGiphyTap;

  final VoidCallback onCreateStickerTap;

  final ItemType? currentlyEditingItemType;

  final VoidCallback onCloseStickerOverlay;

  final List<List<Color>> backgroundColorList;

  /// A callback function that is called when the add Giphy button is tapped
  /// Creates an instance of the widget.
  ///
  /// All parameters are required and must not be null.
  const TopToolsWidget({
    super.key,
    required this.animationsDuration,
    this.selectedBackgroundGradientIndex = 0,
    this.selectedTextBackgroundGradientIndex = 0,
    required this.onScreenTap,
    required this.onPickerTap,
    required this.onToggleTextColorPicker,
    required this.onChangeTextBackground,
    required this.onImagePickerTap,
    this.activeItem,
    required this.onCropTap,
    required this.onAddGiphyTap,
    required this.onCreateStickerTap,
    required this.currentlyEditingItemType,
    required this.onCloseStickerOverlay,
    required this.backgroundColorList,
  });

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree in a given BuildContext and when the dependencies of this widget change.
  @override
  Widget build(BuildContext context) {
    if (currentlyEditingItemType == ItemType.text) {
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
                          backgroundColorList[selectedTextBackgroundGradientIndex],
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
    if (currentlyEditingItemType == ItemType.image) {
      return Positioned(
        top: context.topPadding,
        child: Container(
          width: context.width,
          padding: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.crop, color: Colors.white),
            onPressed: onCropTap,
          ),
        ),
      );
    }
    if (currentlyEditingItemType == ItemType.sticker) {
      return Positioned(
        top: context.topPadding,
        child: Container(
          width: context.width,
          padding: const EdgeInsets.all(8),
          child: IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.white),
            onPressed: onCloseStickerOverlay,
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 8,
                  children: [
                    _TopToolBarIcon(
                      onTap: onPickerTap,
                      gradient: LinearGradient(
                        colors:
                            selectedBackgroundGradientIndex == 0
                                ? [Colors.black26, Colors.black26]
                                : backgroundColorList[selectedBackgroundGradientIndex],
                      ),
                      iconData: Icons.auto_awesome,
                    ),
                    _TopToolBarIcon(onTap: onScreenTap),
                    _TopToolBarIcon(
                      onTap: onImagePickerTap,
                      iconData: Icons.photo_camera_back_outlined,
                    ),
                    _TopToolBarIcon(onTap: onAddGiphyTap, iconData: Icons.gif),
                    _TopToolBarIcon(
                      onTap: onCreateStickerTap,
                      iconData: Icons.cut,
                    ),
                  ],
                ),
      ),
    );
  }
}

class _TopToolBarIcon extends StatelessWidget {
  const _TopToolBarIcon({required this.onTap, this.iconData, this.gradient});

  final VoidCallback onTap;
  final Gradient? gradient;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          gradient: gradient,
          color: gradient != null ? null : Colors.black26,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child:
              iconData != null
                  ? Icon(iconData, color: Colors.white)
                  : Text('Aa', style: GoogleFonts.ubuntu(color: Colors.white)),
        ),
      ),
    );
  }
}
