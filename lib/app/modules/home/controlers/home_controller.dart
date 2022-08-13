// ignore_for_file: prefer_final_fields

import 'package:com_joaojsrbr_reader/app/core/utils/start_download.dart';
import 'package:com_joaojsrbr_reader/app/databases/downloads_db.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/repository/argos_repository.dart';
import 'package:com_joaojsrbr_reader/app/repository/cronos_repository.dart';
import 'package:com_joaojsrbr_reader/app/repository/mangahost_repository.dart';
import 'package:com_joaojsrbr_reader/app/repository/mark_repository.dart';
import 'package:com_joaojsrbr_reader/app/repository/neox_repository.dart';
import 'package:com_joaojsrbr_reader/app/repository/prisma_repository.dart';
import 'package:com_joaojsrbr_reader/app/repository/random_repository.dart';
import 'package:com_joaojsrbr_reader/app/repository/reaper_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
// import 'package:com_joaojsrbr_reader/app/services/scans/argos_services.dart';
// import 'package:com_joaojsrbr_reader/app/services/scans/cronos_services.dart';
// import 'package:com_joaojsrbr_reader/app/services/scans/manga_host_services.dart';
// import 'package:com_joaojsrbr_reader/app/services/scans/mark_services.dart';
// import 'package:com_joaojsrbr_reader/app/services/scans/neox_services.dart';
// import 'package:com_joaojsrbr_reader/app/services/scans/prisma_services.dart';
// import 'package:com_joaojsrbr_reader/app/services/scans/random_services.dart';
// import 'package:com_joaojsrbr_reader/app/services/scans/reaper_services.dart';

// ignore: constant_identifier_names
enum Scans { NEOX, RANDOM, MARK, CRONOS, PRISMA, REAPER, MANGA_HOST, ARGOS }

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late ScrollController scrollController;

  Rx<Scans> scans = Scans.NEOX.obs;

  RxString title = 'Neox - Últimos adicionados'.obs;

  final CacheManager customCacheManager = CacheManager(
    Config(
      'Manga-Anime',
      stalePeriod: const Duration(minutes: 30),
    ),
  );

  RxBool _isLoading = true.obs;

  RxBool get isLoading => _isLoading;

  // Future<void> Function() get handleGetDatas => _handleGetDatas;

  late Rx<LoadingMoreBase<BookItem>> itemBookRepository;

  late List<LoadingMoreBase<BookItem>> repositories;

  // late NeoxRepository neoxRepository;
  // late MarkRepository markRepository;
  // late RandomRepository randomRepository;
  // late CronosRepository cronosRepository;
  // late PrimaRepository primaRepository;
  // late ReaperRepository reaperRepository;
  // late MangaHostRepository mangaHostRepository;
  // late ArgosRepository argosRepository;

  void repositoriesInit() {
    repositories = [
      NeoxRepository(),
      MarkRepository(),
      RandomRepository(),
      CronosRepository(),
      PrimaRepository(),
      ReaperRepository(),
      MangaHostRepository(),
      ArgosRepository(),
    ];
  }

  late TabController tabController;

  Future<void> _handleStartDownload() async {
    final items = await DownloadsDB.db.notFinished;
    if (items.isNotEmpty) startDownload();
  }

  //
  RxInt destinationSelected = 0.obs;
  void onDestinationSelected(int value) {
    destinationSelected.value = value;
    tabController.animateTo(
      value,
      curve: Curves.ease,
    );
  }

  void onSelected(Scans value) {
    scans.value = value;
    switch (scans.value) {
      case Scans.NEOX:
        title.value = 'Neox - Últimos adicionados';
        itemBookRepository.value = repositories[0];

        break;
      case Scans.MARK:
        title.value = 'Mark Scans - Últimos adicionados';
        itemBookRepository.value = repositories[1];

        break;
      case Scans.RANDOM:
        title.value = 'Random Scan - Últimos adicionados';
        itemBookRepository.value = repositories[2];

        break;
      case Scans.CRONOS:
        title.value = 'Cronos Scans - Últimos adicionados';

        itemBookRepository.value = repositories[3];
        break;
      case Scans.PRISMA:
        title.value = 'Prisma Scans - Últimos adicionados';

        itemBookRepository.value = repositories[4];
        break;
      case Scans.REAPER:
        title.value = 'Reaper Scans - Últimos adicionados';

        itemBookRepository.value = repositories[5];
        break;
      case Scans.MANGA_HOST:
        title.value = 'Mangá Host - Últimos adicionados';

        itemBookRepository.value = repositories[6];
        break;
      case Scans.ARGOS:
        title.value = 'Argos - Popular';

        itemBookRepository.value = repositories[7];
        break;
    }
  }

  @override
  void onInit() {
    _handleStartDownload();
    repositoriesInit();
    itemBookRepository = Rx(NeoxRepository());
    FlutterNativeSplash.remove();
    // _handleGetDatas();
    tabController = TabController(
      length: 2,
      animationDuration: const Duration(milliseconds: 400),
      vsync: this,
    );
    scrollController = ScrollController();
    super.onInit();
  }

  Key stringkey(Key? key, String name) {
    return Key('#$name-$key');
  }

  PageStorageKey pageStorageKey(Key? key, String name) {
    return PageStorageKey('#$name-$key');
  }

  RxBool inrefresh = true.obs;

  Future<void> onRefresh() async {
    inrefresh.value = false;
    await itemBookRepository.value.refresh(true);
    inrefresh.value = true;
    // update([20]);
  }

  SliverGridDelegate gridDelegate =
      const SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 320,
    childAspectRatio: 1,
    crossAxisSpacing: 0,
    mainAxisSpacing: 10,
    mainAxisExtent: 280,
  );

  @override
  void onClose() {
    itemBookRepository.value.dispose();
    scrollController.dispose();
    tabController.dispose();
    // customCacheManager.dispose();
    super.onClose();
  }
}
