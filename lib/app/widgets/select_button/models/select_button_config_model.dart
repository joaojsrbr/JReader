import 'package:flutter/material.dart';

const int _initialvalue = 0;

class SelectButtonConfig {
  final bool normal;

  final int initvalue;

  SelectButtonConfig({
    this.initvalue = _initialvalue,
    this.normal = false,
  });
}

class SelectButtonAnimation {
  Widget? initialData;
  final Curve? curve;
  final Duration? duration;
  final Curve? reverseCurve;
  final bool Function(Widget, Widget)? dataDidChange;
  final void Function()? onFadeComplete;
  SelectButtonAnimation({
    this.duration,
    this.onFadeComplete,
    this.curve,
    this.reverseCurve,
    this.initialData,
    this.dataDidChange,
  });
}
