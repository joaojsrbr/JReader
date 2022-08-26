import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  late ScrollController scrollController;
  final TextEditingController searchQuery = TextEditingController();
  final key = GlobalKey<ScaffoldState>();

  String searchText = "";

  List<BookItem> items = [];
  ValueNotifier<bool> isSearching = ValueNotifier(false);
  ValueNotifier<List<BookItem>> searchList = ValueNotifier([]);

  @override
  void onInit() {
    scrollController = ScrollController();

    listener();

    super.onInit();
  }

  void listener() {
    searchQuery.addListener(
      () async {
        if (searchQuery.text.isEmpty) {
          isSearching.value = false;
          searchText = "";
          buildSearchList();
        } else {
          isSearching.value = true;
          searchText = searchQuery.text;
          buildSearchList();
        }
      },
    );
  }

  void buildSearchList() {
    if (searchText.isEmpty) {
      searchList.value = items;
    } else {
      searchList.value = items
          .where((element) =>
              element.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      if (kDebugMode) {
        print('${searchList.value.length}');
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
