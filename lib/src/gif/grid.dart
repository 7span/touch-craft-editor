import 'dart:math';

import 'package:enough_giphy/enough_giphy.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_design_editor/src/gif/image_view.dart';

/// Shows GIFs in a grid
class GiphyGrid extends StatelessWidget {
  /// Shows squared GIFs in columns
  const GiphyGrid.square({
    super.key,
    required this.giphySource,
    this.onSelected,
    this.spacing = 4.0,
    this.borderRadius,
    this.minColumns = 2,
  }) : gridDelegator = _square;

  /// Shows squared GIFs in a varying number of columns
  const GiphyGrid.fixedWidth({
    super.key,
    required this.giphySource,
    this.onSelected,
    this.spacing = 4.0,
    this.borderRadius,
    this.minColumns = 2,
  }) : gridDelegator = _fixedWidth;

  /// Shows GIFs in a varying number of columns
  const GiphyGrid.fixedWidthVaryingHeight({
    super.key,
    required this.giphySource,
    this.onSelected,
    this.spacing = 4.0,
    this.borderRadius,
    this.minColumns = 2,
  }) : gridDelegator = _fixedWidthVaryingHeight;

  /// The source for images
  final GiphySource giphySource;

  /// Method to be called when an image was selected by the user
  final void Function(GiphyGif gif)? onSelected;

  /// The spacing between images
  final double spacing;

  /// The optional border radius
  final BorderRadius? borderRadius;

  /// The minimum number of columns
  final int minColumns;

  /// the grid delegator
  final SliverGridDelegate Function(BuildContext context, GiphyGrid grid)
  gridDelegator;

  @override
  Widget build(BuildContext context) => SliverGrid(
    gridDelegate: gridDelegator(context, this),
    delegate: SliverChildBuilderDelegate((context, index) {
      if (!giphySource.hasElementAt(index)) {
        return null;
      }
      return FutureBuilder<GiphyGif>(
        future: giphySource.load(index),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data != null) {
            final callback = onSelected;
            final content = GestureDetector(
              onTap: callback == null ? null : () => callback(data),
              child: GiphyImageView(
                gif: data,
                isShownInGrid: true,
                fit: BoxFit.cover,
              ),
            );
            final radius = borderRadius;
            if (radius == null) {
              return content;
            } else {
              return ClipRRect(borderRadius: radius, child: content);
            }
          }
          return Center(child: PlatformCircularProgressIndicator());
        },
      );
    }, childCount: giphySource.totalCount),
  );

  static SliverGridDelegate _square(BuildContext context, GiphyGrid grid) =>
      SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: grid.spacing,
        mainAxisSpacing: grid.spacing,
      );

  static SliverGridDelegate _fixedWidth(BuildContext context, GiphyGrid grid) =>
      SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1,
        crossAxisSpacing: grid.spacing,
        mainAxisSpacing: grid.spacing,
      );

  static SliverGridDelegate _fixedWidthVaryingHeight(
    BuildContext context,
    GiphyGrid grid,
  ) => FixedWidthVaryingHeightGridDelegate(grid);
}

/// Layouts a grid with a fixed with but height that depends on the image
class FixedWidthVaryingHeightGridDelegate extends SliverGridDelegate {
  /// Creates a new grid delegate
  FixedWidthVaryingHeightGridDelegate(this.parent);

  /// The parent gid
  final GiphyGrid parent;
  FixedWidthVaryingHeightLayout? _currentLayout;
  SliverConstraints? _currentConstraints;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    // print('getLayout($constraints)');
    final previous = _currentConstraints;
    if (previous?.crossAxisExtent == constraints.crossAxisExtent) {
      return _currentLayout!;
    }
    double columnWidth;
    switch (parent.giphySource.type) {
      case GiphyType.gifs:
        columnWidth = 150;
        break;
      case GiphyType.stickers:
        columnWidth = 100;
        break;
      case GiphyType.emoji:
        columnWidth = 75;
        break;
    }
    var columns =
        ((constraints.crossAxisExtent + parent.spacing) /
                (columnWidth + parent.spacing))
            .floor();
    if (columns < parent.minColumns) {
      columns = parent.minColumns;
    }
    columnWidth =
        (constraints.crossAxisExtent - (columns - 1) * parent.spacing) /
        columns;
    final layout = FixedWidthVaryingHeightLayout(
      columns,
      columnWidth,
      parent.spacing,
      parent.giphySource,
    );
    _currentConstraints = constraints;
    _currentLayout = layout;
    return layout;
  }

  @override
  bool shouldRelayout(covariant SliverGridDelegate oldDelegate) => true;
}

/// Layouts a sliver grid with a fixed with but height that depends on the image
class FixedWidthVaryingHeightLayout extends SliverGridLayout {
  /// Creates a new sliver grid layout
  FixedWidthVaryingHeightLayout(
    this.columns,
    this.columnWidth,
    this.spacing,
    this.source,
  ) : _columnOffsets = List.generate(columns, (index) => 0.0) {
    for (var i = 0; i < source.cacheCount; i++) {
      _calculateGeometry(i);
    }
  }

  /// The number of columns
  final int columns;

  /// The width for each column
  final double columnWidth;

  /// The spacing between images
  final double spacing;

  /// The image source
  final GiphySource source;
  final List<double> _columnOffsets;
  final _geometries = <Rectangle<double>>[];

  Rectangle<double> _calculateGeometry(int index) {
    var columnIndex = index % columns;
    var scrollOffset = _columnOffsets[columnIndex];
    for (var c = 1; c < columns; c++) {
      final cIndex = (index + c) % columns;
      final cScrollOffset = _columnOffsets[cIndex];
      if (cScrollOffset < scrollOffset) {
        scrollOffset = cScrollOffset;
        columnIndex = cIndex;
      }
    }
    final crossAxisOffset = columnIndex * (columnWidth + spacing);
    final crossAxisExtent = columnWidth;
    final gif = source[index]?.recommendedMobileKeyboard;
    final factor = columnWidth / (gif?.widthDouble ?? columnWidth);
    final mainAxisExtent = factor * (gif?.heightDouble ?? columnWidth);
    final rect = Rectangle<double>(
      crossAxisOffset,
      scrollOffset,
      crossAxisExtent,
      mainAxisExtent,
    );
    _geometries.add(rect);
    _columnOffsets[columnIndex] = scrollOffset + mainAxisExtent + spacing;
    return rect;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    // print('getGeometryForChildIndex($index), cached=${_geometries.length}');
    final rect =
        (index < _geometries.length)
            ? _geometries[index]
            : _calculateGeometry(index);
    return SliverGridGeometry(
      scrollOffset: rect.top,
      crossAxisOffset: rect.left,
      mainAxisExtent: rect.height,
      crossAxisExtent: rect.width,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    if (childCount == 0) {
      return 0.0;
    }
    if (childCount <= _geometries.length) {
      final rectangle = _geometries[childCount - 1];
      // print(
      //     'computeMaxScrollOffset(childCount=$childCount):'
      //    ' ${rectangle.bottom}');
      return rectangle.bottom;
    }
    // print(
    //     'computeMaxScrollOffset(childCount=$childCount): '
    // 'guessing ${(childCount ~/ columns) * columnWidth * 2.0}');
    return (childCount ~/ columns) * columnWidth * 2.0;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final geometries = _geometries;
    for (var i = 0; i < geometries.length; i++) {
      final geometry = geometries[i];
      if (geometry.top >= scrollOffset) {
        // print('getMaxChildIndexForScrollOffset($scrollOffset)=$i');
        return i;
      }
    }
    // print(
    //     'getMaxChildIndexForScrollOffset($scrollOffset)=cacheCount == '
    //     '${source.cacheCount}');
    return source.cacheCount;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    final geometries = _geometries;
    for (var i = 0; i < geometries.length; i++) {
      final geometry = geometries[i];
      if (geometry.bottom >= scrollOffset) {
        // print('getMinChildIndexForScrollOffset($scrollOffset)=$i');
        return i;
      }
    }
    // print('getMinChildIndexForScrollOffset($scrollOffset)=0');
    return 0;
  }
}
