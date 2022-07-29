import 'package:A.N.R/app/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Sinopse extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const Sinopse(
    this.text, {
    this.margin,
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      alignment: Alignment.topLeft,
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}

class ShortSinopse extends StatelessWidget {
  final bool isLoading;
  final String text;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const ShortSinopse(
    this.text, {
    this.isLoading = false,
    this.padding,
    this.margin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      alignment: Alignment.topLeft,
      child: isLoading
          ? const ShortSinopseShimmer()
          : Text(
              text,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}

class ShortSinopseShimmer extends StatelessWidget {
  const ShortSinopseShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CustomColors.surface,
      highlightColor: CustomColors.surfaceTwo,
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: BoxDecoration(
          color: CustomColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
