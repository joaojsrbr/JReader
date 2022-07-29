import 'package:flutter/material.dart';

class Grid {
  static SliverGridDelegateWithMaxCrossAxisExtent get sliverDelegate {
    return const SliverGridDelegateWithMaxCrossAxisExtent(
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.72,
      maxCrossAxisExtent: 156,
    );
  }
}
