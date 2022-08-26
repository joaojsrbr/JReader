import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';

class SectionListTitle extends StatelessWidget {
  final String? title;
  final void Function()? viewMore;
  final TextStyle? style;

  const SectionListTitle({this.title, this.viewMore, Key? key, this.style})
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
            title ?? InheritedWidgetValueNotifier.of<String>(context).value,
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
