import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/export_scans.dart';
import 'package:com_joaojsrbr_reader/app/ui/search/controlers/results_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isSearching = ValueNotifier(false);
  ResultsController results = ResultsController();
  final TextEditingController textEditingController = TextEditingController();

  Future<List<BookItem>> _search(Future<List<BookItem>> value) async {
    List<BookItem> templist = [];
    await value.then(
      (value) => templist = value,
      onError: (value) => templist = [],
    );
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
      var temp = await Future.wait(
        [
          _search(ArgosService.search(value)),
          _search(NeoxServices.search(value)),
          _search(RandomServices.search(value)),
          _search(MarkServices.search(value)),
          _search(CronosServices.search(value)),
          _search(PrismaServices.search(value)),
          _search(ReaperServices.search(value)),
          _search(OlympusServices.search(value)),
          _search(MuitoMangaServices.search(value)),
          _search(MangaHostServices.search(value))
        ],
      );
      results.addAll(temp);
    } catch (e) {
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Ocorreu um erro ao buscar pelo livro'),
        ),
      );
    } finally {
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
