import 'package:enough_giphy/enough_giphy.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_design_editor/src/gif/transparent_image.dart';

/// Displays a single GIPHY image
class GiphyImageView extends StatelessWidget {
  /// Creates a widget that displays an [ImageStream]
  /// obtained from the network address of the specified [gif].
  ///
  /// The [gif] argument is required and must not be null.
  /// Set [isShownInGrid] to `true` to select a lower quality GIPHY image.
  ///
  /// Either the [width] and [height] arguments can be specified, or the
  /// widget should be placed in a context that sets tight layout constraints.
  /// Otherwise, the image dimensions will be derived from the
  /// used [GiphyImage].
  ///
  /// All network images are cached regardless of HTTP headers.
  ///
  /// If [excludeFromSemantics] is true, then [semanticLabel] will be ignored.
  ///
  const GiphyImageView({
    super.key,
    required this.gif,
    this.isShownInGrid = false,
    this.errorBuilder,
    this.scale = 1.0,
    this.excludeFromSemantics = false,
    this.semanticLabel,
    this.fadeOutDuration = const Duration(milliseconds: 300),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 400),
    this.fadeInCurve = Curves.easeIn,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.cacheWidth,
    this.cacheHeight,
  });

  /// The associated GIF image
  final GiphyGif gif;

  /// In grid the `recommendedMobileKeyboard` [gif] image is used,
  /// otherwise the `recommendedMobileSend` [gif] will be shown
  final bool isShownInGrid;

  /// A builder function that is called if an error occurs during image loading.
  ///
  /// If this builder is not provided, any exceptions will be reported to
  /// [FlutterError.onError]. If it is provided, the caller should either handle
  /// the exception by providing a replacement widget, or rethrow the exception.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// The duration of the fade-out animation.
  final Duration fadeOutDuration;

  /// The curve of the fade-out animation.
  final Curve fadeOutCurve;

  /// The duration of the fade-in animation for the [gif].
  final Duration fadeInDuration;

  /// The curve of the fade-in animation for the [gif].
  final Curve fadeInCurve;

  /// If non-null, require the image to have this width.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio. This may result in a sudden change if the size of the
  /// placeholder image does not match that of the target image. The size is
  /// also affected by the scale factor.
  final double? width;

  /// If non-null, require the image to have this height.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio. This may result in a sudden change if the size of the
  /// placeholder image does not match that of the target image. The size is
  /// also affected by the scale factor.
  final double? height;

  /// How to inscribe the image into the space allocated during layout.
  ///
  /// The default varies based on the other fields. See the discussion at
  /// [paintImage].
  final BoxFit? fit;

  /// How to align the image within its bounds.
  ///
  /// The alignment aligns the given position in the image to the given position
  /// in the layout bounds. For example, an [Alignment] alignment of (-1.0,
  /// -1.0) aligns the image to the top-left corner of its layout bounds,
  /// while an [Alignment] alignment of (1.0, 1.0) aligns the bottom right of
  /// the image with the bottom right corner of its layout bounds. Similarly, an
  /// alignment of (0.0, 1.0) aligns the bottom middle of the image with the
  /// middle of the bottom edge of its layout bounds.
  ///
  /// If the [alignment] is [TextDirection]-dependent (i.e. if it is a
  /// [AlignmentDirectional]), then an ambient [Directionality] widget
  /// must be in scope.
  ///
  /// Defaults to [Alignment.center].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// How to paint any portions of the layout bounds not covered by the image.
  final ImageRepeat repeat;

  /// Whether to paint the image in the direction of the [TextDirection].
  ///
  /// If this is true, then in [TextDirection.ltr] contexts, the image will be
  /// drawn with its origin in the top left (the "normal" painting direction for
  /// images); and in [TextDirection.rtl] contexts, the image will be drawn with
  /// a scaling factor of -1 in the horizontal direction so that the origin is
  /// in the top right.
  ///
  /// This is occasionally used with images in right-to-left environments, for
  /// images that were designed for left-to-right locales. Be careful, when
  /// using this, to not flip images with integral shadows, text, or other
  /// effects that will look incorrect when flipped.
  ///
  /// If this is true, there must be an ambient [Directionality] widget in
  /// scope.
  final bool matchTextDirection;

  /// Whether to exclude this image from semantics.
  ///
  /// This is useful for images which do not contribute meaningful information
  /// to an application.
  final bool excludeFromSemantics;

  /// A semantic description of the [gif].
  ///
  /// Used to provide a description of the [gif] to TalkBack on Android, and
  /// VoiceOver on iOS.
  ///
  /// This description will be used both while the [gif] is not loaded and
  /// once the image has loaded.
  final String? semanticLabel;

  /// If [cacheWidth] or [cacheHeight] are provided, it indicates to the
  /// engine that the image should be decoded at the specified size. The image
  /// will be rendered to the constraints of the layout or [width] and [height]
  /// regardless of these parameters. These parameters are primarily intended
  /// to reduce the memory usage of [ImageCache].
  ///
  /// In the case where the network image is on the Web platform, the
  /// [cacheWidth]
  /// and [cacheHeight] parameters are ignored as the web engine delegates
  /// image decoding to the web which does not support custom decode sizes.
  final int? cacheWidth;

  /// Compare [cacheWidth]
  final int? cacheHeight;

  /// The `scale` arguments are passed to their
  /// respective [ImageProvider]s (see also [ImageInfo.scale]).
  final double scale;

  @override
  Widget build(BuildContext context) {
    final imageData =
        isShownInGrid
            ? gif.recommendedMobileKeyboard
            : gif.recommendedMobileSend;
    final w = width;
    final h = height;
    final image = FadeInImage.memoryNetwork(
      placeholder: TransparentImage.data,
      image: imageData.url,
      fit: fit,
      excludeFromSemantics: excludeFromSemantics,
      width: w,
      height: h,
      alignment: alignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      fadeInDuration: fadeInDuration,
      fadeInCurve: fadeInCurve,
      fadeOutDuration: fadeOutDuration,
      fadeOutCurve: fadeOutCurve,
      imageCacheHeight: cacheHeight,
      imageCacheWidth: cacheWidth,
      imageErrorBuilder: errorBuilder,
      imageScale: scale,
      imageSemanticLabel: semanticLabel,
    );
    final adaptSize = !isShownInGrid && w == null && h == null;
    if (adaptSize) {
      final iw = imageData.widthDouble;
      final ih = imageData.heightDouble;
      return AspectRatio(aspectRatio: iw / ih, child: image);
    }
    return image;
  }
}
