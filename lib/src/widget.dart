import 'dart:math';
import 'package:flutter/widgets.dart';
import 'types.dart';

/// Intelligently stacks widgets,
/// allowing them to partially overlap
/// for a compact and visually interesting layout.
class OverlapStack extends StatelessWidget {
  /// Creates an overlapping stack, linear array of widgets from an explicit [List].
  OverlapStack({
    super.key,
    this.direction = Axis.horizontal,
    this.align = OverlapStackAlign.center,
    this.minSpacing = .5,
    this.maxSpacing = .8,
    this.leadIndex = -1,
    this.infoIndex = -1,
    this.infoBuilder,
    this.itemLimit = -1,
    this.itemSize,
    required List<Widget> children,
  })  : assert(minSpacing > 0 && maxSpacing >= minSpacing),
        assert(leadIndex >= -1),
        assert(infoIndex >= -1),
        assert(itemLimit >= -1),
        itemCount = children.length,
        itemBuilder = ((context, index) => children[index]);

  /// Creates an overlapping stack, linear array of widgets that are created on demand.
  const OverlapStack.builder({
    super.key,
    this.direction = Axis.horizontal,
    this.align = OverlapStackAlign.center,
    this.minSpacing = .5,
    this.maxSpacing = .8,
    this.leadIndex = -1,
    this.infoIndex = -1,
    this.infoBuilder,
    this.itemLimit = -1,
    this.itemSize,
    required this.itemCount,
    required this.itemBuilder,
  })  : assert(minSpacing > 0 && maxSpacing >= minSpacing),
        assert(leadIndex >= -1),
        assert(infoIndex >= -1),
        assert(itemLimit >= -1),
        assert(itemCount >= 0),
        assert(itemLimit <= itemCount);

  /// The direction to use as the main axis.
  final Axis direction;

  /// How the children should be placed along the main axis.
  final OverlapStackAlign align;

  /// Defines minimum spacing between items,
  /// as a percentage of item extent.
  final double minSpacing;

  /// Defines maximum spacing between items,
  /// as a percentage of item extent.
  final double maxSpacing;

  /// Controls which item appears at the top.
  final int leadIndex;

  /// Controls the position of the info widget (if present).
  final int infoIndex;

  /// Callback for providing details of invisible children.
  final OverlapStackInfoBuilder? infoBuilder;

  /// Number of items to display.
  final int itemLimit;

  /// Defines the size (width or height) of an individual item in the stack.
  final Size? itemSize;

  /// The total number of children this delegate can provide.
  final int itemCount;

  /// Called to build children
  final IndexedWidgetBuilder itemBuilder;

  bool get isHorizontal => direction == Axis.horizontal;
  bool get isVertical => !isHorizontal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isVertical ? itemSize?.width : null,
      height: isHorizontal ? itemSize?.height : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemExtent = isHorizontal
              ? (itemSize?.width ?? constraints.maxHeight)
              : (itemSize?.height ?? constraints.maxWidth);
          final double itemExtentMax = itemExtent * maxSpacing;
          final double itemExtentMin = itemExtent * minSpacing;
          final double itemTrailExtent = itemExtent - itemExtentMin;

          final double maxExtent =
              isHorizontal ? constraints.maxWidth : constraints.maxHeight;
          final double allowedExtent = maxExtent - itemTrailExtent;
          final int itemAllowed = allowedExtent ~/ itemExtentMin;
          final int itemMax = itemLimit < 0 ? itemCount : itemLimit;
          final int itemDisplay = [itemAllowed, itemCount, itemMax].reduce(min);
          final int itemRemaining = itemCount - itemDisplay;

          final double takenSpace = itemDisplay * itemExtentMin;
          final double freeSpace = allowedExtent - takenSpace;
          final double itemSpace = freeSpace / (itemDisplay - 1);
          final double itemExtentSpace = itemExtentMin + itemSpace;
          final double itemExtentFinal = min(itemExtentSpace, itemExtentMax);

          final double takenSpaceAdjusted =
              (itemDisplay * itemExtentFinal) + (itemExtent - itemExtentFinal);
          final double freeSpaceAdjusted = maxExtent - takenSpaceAdjusted;
          final double firstOffset = align == OverlapStackAlign.center
              ? freeSpaceAdjusted / 2
              : align == OverlapStackAlign.end
                  ? freeSpaceAdjusted
                  : 0;

          final bool hasInfo = itemRemaining > 0 && infoBuilder != null;
          if (itemDisplay <= 0) return const SizedBox();

          final lastIndex = itemDisplay - 1;
          final infoPos =
              infoIndex < 0 || infoIndex > lastIndex ? lastIndex : infoIndex;

          final List<Widget> children = List.generate(
            itemDisplay,
            (i) => Positioned(
              top: isVertical ? firstOffset + (i * itemExtentFinal) : null,
              left: isHorizontal ? firstOffset + (i * itemExtentFinal) : null,
              child: i == infoPos && hasInfo
                  ? infoBuilder!(context, itemRemaining + 1)
                  : itemBuilder(context, i),
            ),
            growable: false,
          );
          return Stack(children: _reordering(children, itemDisplay));
        },
      ),
    );
  }

  List<Widget> _reordering(List<Widget> items, int lastIndex) {
    // last on top
    if (leadIndex < 0 || leadIndex >= lastIndex) return items;

    // first on top
    if (leadIndex == 0) return items.reversed.toList();

    // middle on top
    final leftSide = items.getRange(0, leadIndex);
    final rightSide = items.getRange(leadIndex, lastIndex);
    return [
      ...leftSide,
      ...rightSide.toList().reversed,
    ];
  }
}
