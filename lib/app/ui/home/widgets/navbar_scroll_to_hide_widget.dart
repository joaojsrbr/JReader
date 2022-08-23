import 'package:com_joaojsrbr_reader/app/ui/home/widgets/navbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollToHideWidgetState
    extends GetView<ScrollToHideWidgetStateController> {
  final Widget child;
  final Duration duration;
  final double height;
  final List<ScrollController> listcrollControllers;

  const ScrollToHideWidgetState(
      {super.key,
      required this.child,
      required this.listcrollControllers,
      this.duration = const Duration(milliseconds: 150),
      this.height = kBottomNavigationBarHeight});

  @override
  Widget build(BuildContext context) {
    Get.put(
      ScrollToHideWidgetStateController(
          listcrollControllers: listcrollControllers),
    );
    return Obx(
      () => AnimatedContainer(
        duration: duration,
        curve: Curves.linear,
        height: controller.isVisible.value ? height : 0,
        child: Wrap(
          children: [child],
        ),
      ),
    );
  }
}
