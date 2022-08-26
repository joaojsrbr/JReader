import 'package:com_joaojsrbr_reader/app/ui/home/widgets/navbar_to_hide/animated_container_notifier.dart';
import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHideWidgetState extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double height;
  final List<ScrollController> listcrollControllers;
  const ScrollToHideWidgetState({
    super.key,
    required this.child,
    required this.listcrollControllers,
    this.duration = const Duration(milliseconds: 250),
    this.height = kBottomNavigationBarHeight,
  });

  @override
  State<ScrollToHideWidgetState> createState() =>
      _ScrollToHideWidgetStateState();
}

class _ScrollToHideWidgetStateState extends State<ScrollToHideWidgetState> {
  ValueNotifier<bool> isVisible = ValueNotifier(true);

  @override
  void initState() {
    for (var scroll in widget.listcrollControllers) {
      scroll.addListener(() => listen(scroll));
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var scroll in widget.listcrollControllers) {
      scroll.removeListener(() => listen(scroll));
    }
    super.dispose();
  }

  void listen(ScrollController scrollcontroller) {
    if ((scrollcontroller.positions.last.userScrollDirection !=
        ScrollDirection.idle)) {
      final direction = scrollcontroller.positions.last.userScrollDirection;
      if (direction == ScrollDirection.forward) {
        show();
      } else if (direction == ScrollDirection.reverse) {
        hide();
      }
    } else if ((scrollcontroller.positions.first.userScrollDirection !=
        ScrollDirection.idle)) {
      final direction = scrollcontroller.positions.first.userScrollDirection;
      if (direction == ScrollDirection.forward) {
        show();
      } else if (direction == ScrollDirection.reverse) {
        hide();
      }
    }
  }

  void show() {
    if (!isVisible.value) {
      isVisible.value = true;
    }
  }

  void hide() {
    if (isVisible.value) {
      isVisible.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetValueNotifier(
      notifier: isVisible,
      child: AnimatedContainerNotifier(
        height: widget.height,
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}
