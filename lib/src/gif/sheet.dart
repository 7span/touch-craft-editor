import 'package:enough_giphy/enough_giphy.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_design_editor/src/gif/image_view.dart';

import 'grid.dart';

/// What predefined grid should be used
enum GridType {
  /// Square grid with the specified gridMinColumns
  squareFixedColumns,

  /// Square grid with as many columns as fit
  squareFixedWidth,

  /// A stacked columns grid with at least gridMinColumns
  stackedColumns,
}

/// Contains the GIPHY UI components
class GiphySheet extends StatefulWidget {
  /// Creates a new GiphySheet
  const GiphySheet({
    super.key,
    required this.client,
    required this.request,
    this.gridBuilder,
    this.errorBuilder,
    this.searchInputDecoration,
    this.searchLabelText,
    this.searchHintText,
    this.searchEmptyResultText,
    this.searchCancelText,
    this.onSelected,
    this.attribution,
    this.showAttribution = true,
    this.showSearch = true,
    this.showTypeSwitcher = true,
    this.showPreview = false,
    this.keepState = false,
    this.headerGifsText,
    this.headerStickersText,
    this.headerEmojiText,
    this.gridSpacing = 2.0,
    this.gridBorderRadius,
    this.previewBorderRadius,
    this.scrollController,
    this.gridMinColumns = 2,
    this.gridType = GridType.stackedColumns,
  });

  /// The giphy client
  final GiphyClient client;

  /// The current request to giphy
  final GiphyRequest request;

  /// The decoration for the input field
  final InputDecoration? searchInputDecoration;

  /// The label for the search field
  final String? searchLabelText;

  /// The hint shown in an empty search field
  final String? searchHintText;

  /// The text shown when the search yielded no result
  final String? searchEmptyResultText;

  /// The text to cancel the search
  final String? searchCancelText;

  /// The text for GIFs
  final String? headerGifsText;

  /// The text for stickers
  final String? headerStickersText;

  /// The text for emoji
  final String? headerEmojiText;

  /// Method that is informed about the selection of an image
  final void Function(GiphyGif gif)? onSelected;

  /// The attribution visualization
  ///
  /// Compare [showAttribution]
  final Widget? attribution;

  /// Should attribution be shown?
  ///
  /// Compare [attribution]
  final bool showAttribution;

  /// Should the search be shown?
  final bool showSearch;

  /// Should the switch between GIFs, stickers and emoji been shown?
  final bool showTypeSwitcher;

  /// Should a bigger preview of the selected image been shown
  /// before the user can select it?
  final bool showPreview;

  /// The spacing between the individual grid tiles
  final double gridSpacing;

  /// Optional scroll controller
  /// in case this sheet is embedded in a linked scrolling
  /// experience like a `DraggableScrollableSheet`
  final ScrollController? scrollController;

  /// Sliver builder responsible for creating the visual representation of
  /// the given source
  final Widget Function(
    BuildContext context,
    GiphySource source,
    void Function(GiphyGif) onSelected,
  )?
  gridBuilder;

  /// Sliver builder that is invoked when no GIFs could be loaded
  final Widget Function(
    BuildContext context,
    dynamic error,
    StackTrace? stackTrace,
  )?
  errorBuilder;

  /// When `true` the state is kept in a static variable to subsequent calls.
  ///
  /// This helps the user to not repeat a search entry, for example.
  final bool keepState;

  /// The minimum number of columns, defaults to 4
  final int gridMinColumns;

  /// The border radius for images shown in the grid
  final BorderRadius? gridBorderRadius;

  /// The border radius for an image shown in a preview alert
  final BorderRadius? previewBorderRadius;

  /// The type of the predefined grids
  final GridType gridType;

  @override
  State<GiphySheet> createState() => _GiphySheetState();
}

class _GiphySheetState extends State<GiphySheet> {
  static GiphyRequest? _lastRequest;
  late Future<GiphySource> _loaderFuture;
  late InputDecoration _inputDecoration;
  late TextEditingController _searchController;
  late GiphyRequest _currentRequest;

  @override
  void initState() {
    _currentRequest =
        widget.keepState ? _lastRequest ?? widget.request : widget.request;
    _searchController = TextEditingController(
      text: _currentRequest.searchQuery,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _loaderFuture = widget.client.request(_currentRequest);
    _inputDecoration =
        widget.searchInputDecoration ??
        InputDecoration(
          prefixIcon:
              defaultTargetPlatform == TargetPlatform.windows
                  ? null
                  : const Icon(Icons.search),
          hintText: widget.searchHintText ?? 'Search here',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusColor: Colors.black,
          suffix: PlatformIconButton(
            icon: Icon(CommonPlatformIcons.clear),
            onPressed: () {
              _searchController.text = '';
              _reload(_currentRequest.copyWithoutSearchQuery());
            },
          ),
          suffixIcon:
              defaultTargetPlatform == TargetPlatform.windows
                  ? PlatformIconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => _onSearchSubmitted(_searchController.text),
                  )
                  : null,
        );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final attribution = widget.attribution ?? SizedBox();
    return CustomScrollView(
      controller: widget.scrollController,
      slivers: [
        if (widget.showSearch) ...{
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: _buildSearchField(context),
            ),
          ),
        } else if (widget.showAttribution) ...{
          SliverToBoxAdapter(child: attribution),
        },
        if (widget.showTypeSwitcher) ...{
          SliverToBoxAdapter(child: _buildTypeSwitcher(context)),
        },
        FutureBuilder<GiphySource>(
          future: _loaderFuture,
          builder: (context, snapshot) {
            final source = snapshot.data;
            if (source != null) {
              final builder = widget.gridBuilder;
              if (builder != null) {
                return builder(context, source, _onSelected);
              }
              if (source.totalCount == 0) {
                return SliverPadding(
                  padding: EdgeInsets.all(widget.gridSpacing),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        widget.searchEmptyResultText ?? 'Nothing found',
                      ),
                    ),
                  ),
                );
              }
              GiphyGrid grid;
              switch (widget.gridType) {
                case GridType.squareFixedColumns:
                  grid = GiphyGrid.square(
                    giphySource: source,
                    onSelected: _onSelected,
                    spacing: widget.gridSpacing,
                    borderRadius: widget.gridBorderRadius,
                    minColumns: widget.gridMinColumns,
                  );
                  break;
                case GridType.squareFixedWidth:
                  grid = GiphyGrid.fixedWidth(
                    giphySource: source,
                    onSelected: _onSelected,
                    spacing: widget.gridSpacing,
                    borderRadius: widget.gridBorderRadius,
                    minColumns: widget.gridMinColumns,
                  );
                  break;
                case GridType.stackedColumns:
                  grid = GiphyGrid.fixedWidthVaryingHeight(
                    giphySource: source,
                    onSelected: _onSelected,
                    spacing: widget.gridSpacing,
                    borderRadius: widget.gridBorderRadius,
                    minColumns: widget.gridMinColumns,
                  );
                  break;
              }
              return SliverPadding(
                padding: EdgeInsets.all(widget.gridSpacing),
                sliver: grid,
              );
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              final stackTrace = snapshot.stackTrace;
              // ignore: avoid_print
              print('Unable to download source: $error $stackTrace');
              final builder = widget.errorBuilder;
              if (builder != null) {
                return builder(context, error, stackTrace);
              } else {
                return SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const Icon(Icons.error),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Unable to connect to GIPHY, '
                          'please check your internet '
                          'connection.\n\nDetails: $error',
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
            return SliverToBoxAdapter(
              child: Center(child: PlatformCircularProgressIndicator()),
            );
          },
        ),
      ],
    );
  }

  Future<void> _onSelected(GiphyGif gif) async {
    if (widget.showPreview) {
      final approved = await _showPreview(gif);
      if (approved != true) {
        return;
      }
    }
    final callback = widget.onSelected;
    if (callback != null) {
      callback(gif);
    } else {
      Navigator.of(context).pop(gif);
    }
  }

  Widget _buildSearchField(BuildContext context) {
    if (PlatformInfo.isCupertino) {
      return CupertinoSearchFlowTextField(
        enabled: _currentRequest.type != GiphyType.emoji,
        controller: _searchController,
        cancelText: widget.searchCancelText ?? 'Cancel',
        onSubmitted: _onSearchSubmitted,
        title: _inputDecoration.labelText,
      );
    }
    return DecoratedPlatformTextField(
      enabled: _currentRequest.type != GiphyType.emoji,
      decoration: _inputDecoration,
      controller: _searchController,
      textInputAction: TextInputAction.search,
      onSubmitted: _onSearchSubmitted,
    );
  }

  void _onSearchSubmitted(String text) {
    final request =
        text.isEmpty
            ? _currentRequest.copyWithoutSearchQuery()
            : _currentRequest.copyWith(searchQuery: text);
    _reload(request);
  }

  void _reload(GiphyRequest request) {
    _currentRequest = request;
    if (widget.keepState) {
      _lastRequest = request;
    }
    setState(() {
      _loaderFuture = widget.client.request(request);
    });
  }

  Widget _buildTypeSwitcher(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: PlatformToggleButtons(
        isSelected:
            GiphyType.values
                .map((type) => type == _currentRequest.type)
                .toList(),
        onPressed: (index) {
          final request = _currentRequest.copyWith(
            type: GiphyType.values[index],
          );
          _reload(request);
        },
        children:
            GiphyType.values
                .map(
                  (type) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(_getHeaderText(type)),
                  ),
                )
                .toList(),
      ),
    ),
  );

  Future<bool?> _showPreview(GiphyGif gif) {
    final titleWidget = Text(gif.title);
    final username = gif.username;
    Widget giphy = GiphyImageView(gif: gif, fit: BoxFit.contain);
    final radius = widget.previewBorderRadius;
    if (radius != null) {
      giphy = ClipRRect(borderRadius: radius, child: giphy);
    }
    final content =
        (username == null || username.isEmpty)
            ? giphy
            : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  giphy,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Theme.of(context).canvasColor.withAlpha(128),
                      child: PlatformTextButton(
                        child: PlatformText('@${gif.username}'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                          final query = '@${gif.username}';
                          _searchController.text = query;
                          final scrollController = widget.scrollController;
                          if (scrollController != null) {
                            scrollController.animateTo(
                              0.0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                          _reload(_currentRequest.copyWith(searchQuery: query));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
    if (PlatformInfo.isCupertino) {
      return showCupertinoDialog<bool>(
        context: context,
        builder:
            (context) => CupertinoAlertDialog(
              title: titleWidget,
              content: content,
              actions: [
                CupertinoButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Icon(CupertinoIcons.clear_circled),
                ),
                CupertinoButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Icon(CupertinoIcons.check_mark_circled),
                ),
              ],
            ),
      );
    }
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: titleWidget,
            content: content,
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(false),
                icon: Icon(Icons.clear, color: onSurfaceColor),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(true),
                icon: Icon(Icons.check, color: onSurfaceColor),
              ),
            ],
          ),
    );
  }

  String _getHeaderText(GiphyType type) {
    switch (type) {
      case GiphyType.gifs:
        return widget.headerGifsText ?? 'GIFs';
      case GiphyType.stickers:
        return widget.headerStickersText ?? 'Stickers';
      case GiphyType.emoji:
        return widget.headerEmojiText ?? 'Emoji';
    }
  }
}

/// Provides the data for a transparent image
class TransparentImage {
  TransparentImage._();

  /// Contains the binary data of the transparent image
  static final Uint8List data = Uint8List.fromList([
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
  ]);
}
