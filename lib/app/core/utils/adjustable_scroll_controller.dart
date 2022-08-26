import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

class AdjustableScrollController extends ScrollController {
  AdjustableScrollController({int extraScrollSpeed = 35}) {
    super.addListener(
      () {
        ScrollDirection scrollDirection = super.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = super.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? extraScrollSpeed
                  : -extraScrollSpeed);
          scrollEnd = min(super.position.maxScrollExtent,
              max(super.position.minScrollExtent, scrollEnd));
          jumpTo(scrollEnd);
        }
      },
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({super.parent});

  @override
  CustomScrollPhysics applyTo(ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final tolerance = super.tolerance;
    if ((velocity.abs() < tolerance.velocity) ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity < 0.0 && position.pixels <= position.minScrollExtent)) {
      return null;
    }
    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      friction: 0.035,
      tolerance: tolerance,
    );
  }
}
