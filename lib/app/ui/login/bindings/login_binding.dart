import 'package:com_joaojsrbr_reader/app/ui/login/controlers/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put<LoginController>(LoginController());
    Get.put<LoginController>(LoginController());
  }
}
