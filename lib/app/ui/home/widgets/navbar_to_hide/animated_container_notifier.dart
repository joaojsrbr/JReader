import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';

class AnimatedContainerNotifier extends StatelessWidget {
  const AnimatedContainerNotifier(
      {super.key,
      required this.child,
      required this.duration,
      required this.height});
  final Duration duration;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final value = InheritedWidgetValueNotifier.of<bool>(context).value as bool;
    return AnimatedContainer(
      duration: duration,
      curve: Curves.fastOutSlowIn,
      height: value ? height : 0,
      child: Wrap(
        children: [child],
      ),
    );
  }
}
