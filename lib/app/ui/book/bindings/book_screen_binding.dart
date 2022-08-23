import 'package:get/get.dart';

import '../controlers/book_screen_controller.dart';

class BookScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => BookScreenController(),
    );
  }
}
