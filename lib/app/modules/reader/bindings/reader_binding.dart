import 'package:A.N.R/app/modules/reader/controlers/reader_controller.dart';
import 'package:get/get.dart';

class ReaderBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReaderController>(() => ReaderController());
  }
}
