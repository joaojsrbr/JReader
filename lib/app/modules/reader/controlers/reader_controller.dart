import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class ReaderController extends GetxController {
  void Function()? previousScroll;
  void Function()? nextScroll;
  final CacheManager cacheManager = DefaultCacheManager();
  final RxInt currentIndex = 0.obs;
}
