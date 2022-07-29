import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:A.N.R/app/core/themes/colors.dart';

class AccentSubtitleWithDots extends StatelessWidget {
  final bool isLoading;
  final List<String> data;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const AccentSubtitleWithDots(
    this.data, {
    this.margin,
    this.padding,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  List<Widget> _handleData() {
    List<Widget> items = [];

    for (var value in data) {
      if (value == '') continue;

      items.add(AccentSubtitleText(value));
      items.add(const AccentSubtitleDot());
    }

    if (items.isNotEmpty) items.removeLast();

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: isLoading ? const [AccentSubtitleShimmer()] : _handleData(),
      ),
    );
  }
}

class AccentSubtitleText extends StatelessWidget {
  final String text;

  const AccentSubtitleText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: CustomColors.accent,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class AccentSubtitleDot extends StatelessWidget {
  const AccentSubtitleDot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(40, 40, 40, 1),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class AccentSubtitleShimmer extends StatelessWidget {
  final double? width;

  const AccentSubtitleShimmer({this.width, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CustomColors.surface,
      highlightColor: CustomColors.surfaceTwo,
      child: Container(
        width: width ?? 280,
        height: 22,
        decoration: BoxDecoration(
          color: CustomColors.surface,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
