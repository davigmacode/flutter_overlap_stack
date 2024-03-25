import 'dart:math';
import 'package:flutter/widgets.dart';
import 'types.dart';

class OverlapStack extends StatelessWidget {
  const OverlapStack({
    super.key,
    this.direction = Axis.horizontal,
    this.align = OverlapStackAlign.center,
    this.minCoverage = .5,
    this.maxCoverage = .9,
    this.leadIndex = -1,
    this.infoIndex = -1,
    this.infoBuilder,
    this.itemLimit = -1,
    required this.itemSize,
    required this.itemLength,
    required this.itemBuilder,
  })  : assert(minCoverage > 0 && maxCoverage >= minCoverage),
        assert(itemLength >= 0),
        assert(itemLimit <= itemLength);

  final Axis direction;
  final OverlapStackAlign align;
  final double minCoverage;
  final double maxCoverage;
  final int leadIndex;
  final int infoIndex;
  final int itemLimit;
  final Size itemSize;
  final int itemLength;
  final IndexedWidgetBuilder itemBuilder;
  final OverlapStackInfoBuilder? infoBuilder;

  bool get isHorizontal => direction == Axis.horizontal;
  bool get isVertical => !isHorizontal;

  List<Widget> _itemLayering(List<Widget> items, int lastIndex) {
    // last on top
    if (leadIndex == -1 || leadIndex >= lastIndex) return items;

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isVertical ? itemSize.width : null,
      height: isHorizontal ? itemSize.height : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemExtent =
              isHorizontal ? itemSize.width : itemSize.height;
          final double itemExtentMax = itemExtent * maxCoverage;
          final double itemExtentMin = itemExtent * minCoverage;
          final double itemTrailExtent = itemExtent - itemExtentMin;

          final double maxExtent =
              isHorizontal ? constraints.maxWidth : constraints.maxHeight;
          final double allowedExtent = maxExtent - itemTrailExtent;
          final int itemAllowed = allowedExtent ~/ itemExtentMin;
          final int itemMax = itemLimit < 0 ? itemLength : itemLimit;
          final int itemDisplay =
              [itemAllowed, itemLength, itemMax].reduce(min);
          final int itemRemaining = itemLength - itemDisplay;

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

          return Stack(children: _itemLayering(children, itemDisplay));
        },
      ),
    );
  }
}
