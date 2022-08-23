import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ScrollToHideWidgetStateController extends GetxController {
  ScrollToHideWidgetStateController({required this.listcrollControllers});

  final List<ScrollController> listcrollControllers;

  RxBool isVisible = true.obs;

  @override
  void onInit() {
    for (var scroll in listcrollControllers) {
      scroll.addListener(() => listen(scroll));
    }
    super.onInit();
  }

  @override
  void onClose() {
    for (var scroll in listcrollControllers) {
      scroll.removeListener(() => listen(scroll));
    }
    super.onClose();
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
}
