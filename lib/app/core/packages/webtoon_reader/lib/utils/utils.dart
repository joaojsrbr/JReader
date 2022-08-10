import 'package:flutter/material.dart';

class DoubleTween extends Tween<double?> {
  DoubleTween({double? begin, double? end}) : super(begin: begin, end: end);

  @override
  double lerp(double t) => (begin! + (end! - begin!) * t);
}

class OffsetTween extends Tween<Offset?> {
  OffsetTween({Offset? begin, Offset? end}) : super(begin: begin, end: end);

  @override
  Offset lerp(double t) => (begin! + (end! - begin!) * t);
}
