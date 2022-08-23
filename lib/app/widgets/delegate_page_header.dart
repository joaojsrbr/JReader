import 'package:flutter/material.dart';

class DelegatePageHeader extends SliverPersistentHeaderDelegate {
  DelegatePageHeader({
    required this.maxExtent,
    required this.minExtent,
    required this.builder,
    // required this.vsync,
  }) : super();
  final Widget Function(double shrinkOffset, bool overlapsContent) builder;
  @override
  final double minExtent;
  @override
  final double maxExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(shrinkOffset, overlapsContent);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
