import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ScrollToHideWidgetStateController extends GetxController {
  // final ScrollController scrollController;
  // final ScrollController favoritecontroller;
  ScrollToHideWidgetStateController({required this.listcrollControllers});

  final List<ScrollController> listcrollControllers;

  RxBool isVisible = true.obs;

  @override
  void onInit() {
    for (var scroll in listcrollControllers) {
      scroll.addListener(() => listen(scroll));
    }
    // scrollController.addListener(listen);
    // favoritecontroller.addListener(listen2);
    super.onInit();
  }

  @override
  void dispose() {
    for (var scroll in listcrollControllers) {
      scroll.removeListener(() => listen(scroll));
    }
    // scrollController.removeListener(listen);
    // favoritecontroller.removeListener(listen2);
    super.dispose();
  }

  // void listen() {
  //   if (scrollController.position.pixels >= 68) {
  //     hide();
  //   } else {
  //     show();
  //   }
  // }

  void listen(ScrollController scrollController) {
    final direction = scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.forward) {
      show();
    } else if (direction == ScrollDirection.reverse) {
      hide();
    }
  }

  void show() {
    if (!isVisible.value) {
      isVisible.value = true;
      update();
    }
  }

  void hide() {
    if (isVisible.value) {
      isVisible.value = false;
      update();
    }
  }
}
