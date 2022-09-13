import 'package:flutter/material.dart';

class SectionListTitle extends StatelessWidget {
  final String title;
  final void Function()? viewMore;
  final TextStyle? style;

  const SectionListTitle(
      {required this.title, this.viewMore, Key? key, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('SectionListTitle');
    return Container(
      width: double.infinity,
      // margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: style ?? Theme.of(context).textTheme.titleSmall,
          ),
          TextButton(
            onPressed: viewMore,
            child: Text(viewMore != null ? 'Ver mais' : ''),
          ),
        ],
      ),
    );
  }
}
