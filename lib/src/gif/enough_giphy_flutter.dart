import 'package:enough_giphy/enough_giphy.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/cupertino.dart' show showCupertinoModalPopup;
import 'package:flutter/material.dart';
import 'package:touch_craft_editor/src/gif/sheet.dart';

export 'package:enough_giphy/enough_giphy.dart';

/// Helper class for showing a GIPHY picker
class Giphy {
  Giphy._();

  /// Picks a GIPHY image
  ///
  /// Specify your GIPHY [apiKey] that you can create at
  /// https://developers.giphy.com/dashboard/?create=true
  ///
  /// If you have generated the user's random ID before, you can specify it
  /// with [userRandomId].
  ///
  /// Choose between gifs, stickers and emoji with [type] that defaults to
  /// [GiphyType.gifs].
  ///
  /// Optionally specify the two-letter language code in [lang] to localize
  /// the experience.
  ///
  /// You can change the [rating] which defaults to [GiphyRating.g] meaning
  /// all-ages content.
  ///
  /// Set [showAttribution] to `false` to hide the attribution or specify
  /// your own attribution widget with [attribution].
  ///
  /// Disable search by setting [showSearch] to `false`.
  ///
  /// Disable the user switching between gifs, stickers and emoji by
  /// setting [showTypeSwitcher] to `false`.
  ///
  /// Enable showing a high quality preview before returning a selection
  /// by setting [showPreview] to `true`.
  ///
  /// Enable keeping the state of the currently selected type and search
  /// between invocations by setting [keepState] to `true`.
  ///
  /// Show you own UI on top of the GIPHY sheet after the user has selected
  /// a [GiphyGif] by setting your custom `onSelected` callback in the
  /// [gridBuilder].
  ///
  /// Localize the UI by setting [searchLabelText], [searchHintText],
  /// [searchEmptyResultText], [searchCancelText], [headerGifsText],
  /// [headerStickersText] and [headerEmojiText].
  ///
  /// Adapt the minimum number of columns shown with [gridMinColumns],
  /// which defaults to `2`.
  ///
  /// Adapt the spacing between columns using [gridSpacing], defaults to `4.0`.
  ///
  /// Customize the [ClipRRect] border by defining your own [gridBorderRadius].
  /// This defaults to
  /// ```dart
  /// BorderRadius.only(
  ///   topLeft: Radius.circular(8.0),
  ///   bottomRight: Radius.circular(8.0)
  /// )```.
  ///
  /// Select one of the predefined grid types using [gridType] that
  /// defaults to [GridType.stackedColumns].
  ///
  /// Show your own grid or list by setting your custom [gridBuilder] callback.
  ///
  /// Enable your own error handler by setting  a custom [errorBuilder]
  /// callback.
  ///
  /// Disable using a platform-specific bottom sheet by setting
  /// [usePlatformBottomSheet] to `false`.
  static Future<GiphyGif?> getGif({
    required BuildContext context,
    required String apiKey,
    String? userRandomId,
    GiphyType type = GiphyType.gifs,
    GiphyRating rating = GiphyRating.g,
    String lang = GiphyLanguage.english,
    bool showAttribution = true,
    Widget? attribution,
    bool showSearch = true,
    bool showTypeSwitcher = true,
    bool showPreview = false,
    BorderRadius? previewBorderRadius = const BorderRadius.only(
      topLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(8.0),
    ),
    bool keepState = false,
    String? searchLabelText,
    String? searchHintText,
    String? searchEmptyResultText,
    String? searchCancelText,
    String? headerGifsText,
    String? headerStickersText,
    String? headerEmojiText,
    int gridMinColumns = 2,
    double gridSpacing = 4.0,
    BorderRadius? gridBorderRadius = const BorderRadius.only(
      topLeft: Radius.circular(8.0),
      bottomRight: Radius.circular(8.0),
    ),
    GridType gridType = GridType.stackedColumns,
    Widget Function(
      BuildContext context,
      GiphySource source,
      void Function(GiphyGif) onSelected,
    )? gridBuilder,
    Widget Function(
      BuildContext context,
      dynamic error,
      StackTrace? stackTrace,
    )? errorBuilder,
    bool usePlatformBottomSheet = true,
  }) async {
    final client = GiphyClient(apiKey: apiKey, randomId: userRandomId);
    final request = GiphyRequest.trending(
      type: type,
      language: lang,
      rating: rating,
    );

    final result = await _showBottomSheet<GiphyGif>(
      context: context,
      usePlatformBottomSheet: usePlatformBottomSheet,
      builder: (context, scrollController) => Container(
        color: Theme.of(context).canvasColor,
        child: GiphySheet(
          client: client,
          request: request,
          scrollController: scrollController,
          showAttribution: showAttribution,
          attribution: attribution,
          showSearch: showSearch,
          showTypeSwitcher: showTypeSwitcher,
          showPreview: showPreview,
          previewBorderRadius: previewBorderRadius,
          keepState: keepState,
          gridBuilder: gridBuilder,
          errorBuilder: errorBuilder,
          searchLabelText: searchLabelText,
          searchHintText: searchHintText,
          searchEmptyResultText: searchEmptyResultText,
          searchCancelText: searchCancelText,
          headerGifsText: headerGifsText,
          headerStickersText: headerStickersText,
          headerEmojiText: headerEmojiText,
          gridSpacing: gridSpacing,
          gridMinColumns: gridMinColumns,
          gridBorderRadius: gridBorderRadius,
          gridType: gridType,
        ),
      ),
    );
    client.close();
    return result;
  }

  static Future<T?> _showBottomSheet<T>({
    required bool usePlatformBottomSheet,
    required BuildContext context,
    required Widget Function(BuildContext, ScrollController) builder,
  }) {
    if (usePlatformBottomSheet && PlatformInfo.isCupertino) {
      return _showBottomSheetCupertino(context, builder);
    }
    return _showBottomSheetMaterial(context, builder);
  }

  static Future<T?> _showBottomSheetMaterial<T>(
    BuildContext context,
    Widget Function(BuildContext, ScrollController) builder,
  ) =>
      showModalBottomSheet<T?>(
        context: context,
        isScrollControlled: true,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        backgroundColor: Colors.transparent,
        builder: (context) => InkWell(
          onTap: () => Navigator.of(context).pop(null),
          child: SizedBox.expand(
            child: DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              expand: false,
              builder: builder,
            ),
          ),
        ),
      );

  static Future<T?> _showBottomSheetCupertino<T>(
    BuildContext context,
    Widget Function(BuildContext, ScrollController) builder,
  ) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => SizedBox.expand(
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            maxChildSize: 0.9,
            expand: false,
            builder: builder,
          ),
        ),
      );
}
