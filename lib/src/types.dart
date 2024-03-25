import 'package:flutter/widgets.dart';

typedef OverlapStackInfoBuilder = Widget Function(
  BuildContext context,
  int remaining,
);

enum OverlapStackAlign { start, center, end }
