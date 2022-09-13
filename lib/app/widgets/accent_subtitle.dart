// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AccentSubtitleWithDots extends StatelessWidget {
  final bool isLoading;
  final List<String> data;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color baseColor;
  final Color highlightColor;

  const AccentSubtitleWithDots(
    this.data, {
    this.margin,
    this.padding,
    required this.baseColor,
    required this.highlightColor,
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
        children: _handleData(),
        // children: isLoading
        //     ? [
        //         AccentSubtitleShimmer(
        //           baseColor: baseColor,
        //           highlightColor: highlightColor,
        //         ),
        //       ]
        //     : _handleData(),
      ),
    );
  }
}

class AccentSubtitleText extends StatelessWidget {
  final String text;
  final Color? textColor;

  const AccentSubtitleText(
    this.text, {
    Key? key,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
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
  final Color baseColor;
  final Color highlightColor;

  const AccentSubtitleShimmer({
    Key? key,
    this.width,
    required this.baseColor,
    required this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width ?? 200,
        height: 22,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
