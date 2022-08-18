import 'package:flutter/material.dart';

class Grid {
  Grid._();
  static SliverGridDelegateWithMaxCrossAxisExtent get slivergrid {
    return const SliverGridDelegateWithMaxCrossAxisExtent(
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 0.72,
      maxCrossAxisExtent: 156,
    );
  }

  static SliverGridDelegate get sliverlist {
    return const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 320,
      childAspectRatio: 1,
      crossAxisSpacing: 0,
      mainAxisSpacing: 10,
      mainAxisExtent: 280,
    );
  }
}
