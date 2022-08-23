import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  late ScrollController scrollController;

  @override
  void onInit() {
    scrollController = ScrollController();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
