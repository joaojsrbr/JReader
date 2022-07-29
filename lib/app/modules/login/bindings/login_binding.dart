import 'package:A.N.R/app/modules/login/controlers/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put<LoginController>(LoginController());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
