import 'package:com_joaojsrbr_reader/app/ui/search/controlers/search_controller.dart';
import 'package:get/get.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(() => SearchController());
  }
}
