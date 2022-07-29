import 'package:A.N.R/app/modules/favorites/controlers/favorites_controller.dart';
import 'package:A.N.R/app/modules/home/widget/navbar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScrollToHideWidgetState
    extends GetView<ScrollToHideWidgetStateController> {
  final Widget child;
  final Duration duration;
  final double height;
  final ScrollController scrollController;

  const ScrollToHideWidgetState(
      {Key? key,
      required this.child,
      required this.scrollController,
      this.duration = const Duration(milliseconds: 150),
      this.height = kBottomNavigationBarHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritecontroller =
        Get.put<FavoritesController>(FavoritesController()).scrollController;
    Get.put(ScrollToHideWidgetStateController(
        scrollController: scrollController,
        favoritecontroller: favoritecontroller));

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
