// ignore_for_file: prefer_final_fields

import 'package:com_joaojsrbr_reader/app/core/constants/providers.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/export_scans.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<BookItem> results = <BookItem>[].obs;
  Rx<Providers> provider = Providers.NEOX.obs;

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

    try {
      results.value = [];
      // _getSearch(value);

      results.addAll(await _search(ArgosService.search(value)));

      results.addAll(await _search(NeoxServices.search(value)));

      results.addAll(await _search(RandomServices.search(value)));

      results.addAll(await _search(MarkServices.search(value)));

      results.addAll(await _search(CronosServices.search(value)));

      results.addAll(await _search(PrismaServices.search(value)));

      results.addAll(await _search(ReaperServices.search(value)));

      results.addAll(await _search(OlympusServices.search(value)));

      results.addAll(await _search(MangaHostServices.search(value)));

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
      results = results;
      isLoading.value = false;
    }

    // List<BookItem> results = [];

    // try {
    //   results = [];
    // } catch (e) {
    //   final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    //   messenger.clearSnackBars();
    //   messenger.showSnackBar(
    //     const SnackBar(content: Text('Ocorreu um erro ao buscar pelo livro')),
    //   );
    // } finally {
    //   results = results;
    //   isLoading.value = false;
    // }
  }
}
