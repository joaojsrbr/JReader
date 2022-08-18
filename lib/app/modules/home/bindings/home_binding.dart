import 'package:com_joaojsrbr_reader/app/modules/favorites/controlers/favorites_controller.dart';
import 'package:com_joaojsrbr_reader/app/modules/home/controlers/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<FavoritesController>(FavoritesController());
    // Get.put(NotificationService(), permanent: true);
  }
}
