import 'package:get/get.dart';

class WebtoonController extends GetxController {
  late RxBool showAppbar;

  // ScrollController get scrollController => _scrollController;
  // ScrollController get scrollController => _scrollController;
  // ScrollController get scrollController => _scrollController;

  @override
  void onInit() {
    showAppbar = true.obs;
    super.onInit();
  }

  @override
  void onClose() {
    showAppbar.close();
    super.onClose();
  }
}
