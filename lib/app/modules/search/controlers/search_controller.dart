// ignore_for_file: prefer_final_fields

import 'package:A.N.R/app/core/constants/providers.dart';
import 'package:A.N.R/app/models/book_item.dart';
import 'package:A.N.R/app/services/scans/random_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:A.N.R/app/services/scans/argos_services.dart';
import 'package:A.N.R/app/services/scans/cronos_services.dart';
import 'package:A.N.R/app/services/scans/mark_services.dart';
import 'package:A.N.R/app/services/scans/neox_services.dart';
import 'package:A.N.R/app/services/scans/prisma_services.dart';
import 'package:A.N.R/app/services/scans/reaper_services.dart';
import 'package:A.N.R/app/services/scans/manga_host_services.dart';
// import 'package:A.N.R/app/services/scans/random_services.dart';

class SearchController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<BookItem> results = <BookItem>[].obs;
  Rx<Providers> provider = Providers.NEOX.obs;

  // RxList<BookItem> _neox = <BookItem>[].obs;
  // RxList<BookItem> _mark = <BookItem>[].obs;
  // RxList<BookItem> _random = <BookItem>[].obs;
  // RxList<BookItem> _cronos = <BookItem>[].obs;
  // RxList<BookItem> _prisma = <BookItem>[].obs;
  // RxList<BookItem> _reaper = <BookItem>[].obs;
  // RxList<BookItem> _mangaHost = <BookItem>[].obs;
  // RxList<BookItem> _argos = <BookItem>[].obs;
  // RxList<BookItem> get neox => _neox;
  // RxList<BookItem> get mark => _mark;
  // RxList<BookItem> get random => _random;
  // RxList<BookItem> get cronos => _cronos;
  // RxList<BookItem> get prisma => _prisma;
  // RxList<BookItem> get reaper => _reaper;
  // RxList<BookItem> get mangaHost => _mangaHost;
  // RxList<BookItem> get argos => _argos;

  // Future<void> _getSearch(String value) async {
  //   final items = await Future.wait([
  //     NeoxServices.search(value),
  //     MarkServices.search(value),
  //     RandomServices.search(value),
  //     CronosServices.search(value),
  //     PrismaServices.search(value),
  //     ReaperServices.search(value),
  //     MangaHostServices.search(value),
  //     ArgosService.search(value),
  //   ]);
  //   _neox.value = items[0];
  //   _mark.value = items[1];
  //   _random.value = items[2];
  //   _cronos.value = items[3];
  //   _prisma.value = items[4];
  //   _reaper.value = items[5];
  //   _mangaHost.value = items[6];
  //   _argos.value = items[7];
  //   isLoading.value = false;
  // }

  Future<List<BookItem>> _search(Future<List<BookItem>> value) async {
    var templist = await value;
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
