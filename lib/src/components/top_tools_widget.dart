import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/constants/enums.dart';
import 'package:flutter_design_editor/src/extensions/context_extension.dart';
import 'package:flutter_design_editor/src/models/canvas_element.dart';
import 'package:flutter_svg/svg.dart';

/// A widget for displaying the top tools.
///
/// This widget is a part of the UI where the user can interact with the top tools.
/// It is a stateless widget that takes several parameters to control its behavior and appearance.
/// It uses a Positioned widget to display the top tools, and the user can interact with it by tapping on it.
class TopToolsWidget extends StatelessWidget {
  /// The duration of animations within the widget.
  final Duration animationsDuration;

  /// The active item that can be interacted with.
  final CanvasElement? activeItem;

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

  /// To select image from gallery.
  final VoidCallback onImagePickerTap;

  /// A callback function that is called when the crop button is tapped.
  final VoidCallback onCropTap;

  /// A callback function that is called when the Add-Giphy button is tapped.
  final VoidCallback onAddGiphyTap;

  /// A callback function that is called when the user taps on sticker button.
  final VoidCallback onCreateStickerTap;

  /// Current ItemType that is getting edditing.
  final ItemType? currentlyEditingItemType;

  /// A callback function that is called when the user taps on blank screen to close overlay.
  final VoidCallback onCloseStickerOverlay;

  /// list of background gradient colors.
  final List<List<Color>> backgroundColorList;

  /// A callback function that is called when the user taps the download button.
  final VoidCallback onDownloadTap;

  // These variables are used to hide and show buttons for Design Editor features.
  final bool shouldShowGifButton;
  final bool shouldShowImageButton;
  final bool shouldShowTextButton;
  final bool shouldShowStickerButton;
  final bool shouldShowBackgroundGradientButton;
  final bool shouldShowDownloadButton;

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
    required this.onDownloadTap,
    this.activeItem,
    required this.onCropTap,
    required this.onAddGiphyTap,
    required this.onCreateStickerTap,
    required this.currentlyEditingItemType,
    required this.onCloseStickerOverlay,
    required this.backgroundColorList,
    required this.shouldShowGifButton,
    required this.shouldShowImageButton,
    required this.shouldShowTextButton,
    required this.shouldShowStickerButton,
    required this.shouldShowBackgroundGradientButton,
    required this.shouldShowDownloadButton,
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
          padding: const EdgeInsets.all(4),
          child: IconButton(
            icon: const Icon(Icons.cancel, color: Colors.white, size: 30),
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
                    if (shouldShowDownloadButton) ...[
                      _TopToolBarIcon(
                        onTap: onDownloadTap,
                        imagePath: 'assets/download.svg',
                      ),
                      Spacer(),
                    ],
                    if (shouldShowBackgroundGradientButton)
                      _TopToolBarIcon(
                        onTap: onPickerTap,
                        imagePath: 'assets/background.svg',
                      ),
                    if (shouldShowTextButton)
                      _TopToolBarIcon(
                        onTap: onScreenTap,
                        imagePath: 'assets/text.svg',
                      ),
                    if (shouldShowImageButton)
                      _TopToolBarIcon(
                        onTap: onImagePickerTap,
                        imagePath: 'assets/gallery.svg',
                      ),
                    if (shouldShowGifButton)
                      _TopToolBarIcon(
                        onTap: onAddGiphyTap,
                        imagePath: 'assets/gif.svg',
                      ),
                    if (shouldShowStickerButton)
                      _TopToolBarIcon(
                        onTap: onCreateStickerTap,
                        imagePath: 'assets/sticker.svg',
                      ),
                  ],
                ),
      ),
    );
  }
}

class _TopToolBarIcon extends StatelessWidget {
  const _TopToolBarIcon({required this.onTap, required this.imagePath});

  final VoidCallback onTap;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Center(
          child: SvgPicture.asset(
            imagePath,
            height: 19,
            width: 19,
            package: 'flutter_design_editor',
          ),
        ),
      ),
    );
  }
}
