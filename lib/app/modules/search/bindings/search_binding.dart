import 'package:A.N.R/app/modules/search/controlers/search_controller.dart';
import 'package:get/get.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SearchController>(SearchController());
  }
}
