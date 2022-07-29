import 'package:A.N.R/app/modules/favorites/controlers/favorites_controller.dart';
import 'package:get/get.dart';

class FavoritesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}
