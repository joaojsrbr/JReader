// ignore_for_file: prefer_final_fields, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/agregadores/muito_manga_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/export_scans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isSearching = ValueNotifier(false);
  ValueNotifier<List<BookItem>> results = ValueNotifier([]);
  final TextEditingController textEditingController = TextEditingController();

  Future<List<BookItem>> _search(Future<List<BookItem>> value) async {
    List<BookItem> templist = [];
    await value.then((value) => templist = value);
    // var templist = await value;
    if (templist.isEmpty) {
      return [];
    } else {
      return templist;
    }
  }

  Future<void> onSubmitted(String value, BuildContext context) async {
    isLoading.value = true;
    isSearching.value = isLoading.value ? false : true;

    try {
      results.value = [];
      // _getSearch(value);

      results.value.addAll(await _search(ArgosService.search(value)));
      results.notifyListeners();
      results.value.addAll(await _search(NeoxServices.search(value)));
      results.notifyListeners();
      results.value.addAll(await _search(RandomServices.search(value)));
      results.notifyListeners();
      results.value.addAll(await _search(MarkServices.search(value)));
      results.notifyListeners();
      results.value.addAll(await _search(CronosServices.search(value)));
      results.notifyListeners();
      results.value.addAll(await _search(PrismaServices.search(value)));
      results.notifyListeners();
      results.value.addAll(await _search(ReaperServices.search(value)));
      results.notifyListeners();
      results.value.addAll(await _search(OlympusServices.search(value)));
      results.notifyListeners();
      results.value.addAll(await _search(MuitoMangaServices.search(value)));
      results.notifyListeners();
      results.value.addAll(await _search(MangaHostServices.search(value)));
      results.notifyListeners();

      // results.value = await search(value);

    } catch (e) {
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro ao buscar pelo livro'),
        ),
      );
    } finally {
      results.value = results.value;
      isLoading.value = false;
      isSearching.value = isLoading.value
          ? false
          : textEditingController.text.isNotEmpty
              ? true
              : false;
    }
  }

  @override
  void onInit() {
    textEditingController.addListener(
      () async {
        if (textEditingController.text.isEmpty) {
          if (!isLoading.value) {
            isSearching.value = false;
          }
        }
      },
    );

    super.onInit();
  }
}
