import 'package:com_joaojsrbr_reader/app/modules/book/controlers/book_screen_controller.dart';
import 'package:get/get.dart';

class BookScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => BookScreenController(),
    );
  }
}
