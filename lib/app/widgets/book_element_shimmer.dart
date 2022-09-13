// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookElementShimmer extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final Color baseColor;
  final Color highlightColor;

  const BookElementShimmer({
    Key? key,
    this.margin,
    required this.baseColor,
    required this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: 112,
          height: 158.49,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
