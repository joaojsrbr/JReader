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

  Rx<Scans> scans = Scans.NEOX.obs;

  RxString title = 'Neox - Últimos adicionados'.obs;

  late CacheManager customCacheManager;

  RxBool _isLoading = true.obs;

  RxBool get isLoading => _isLoading;

  // Future<void> Function() get handleGetDatas => _handleGetDatas;

  late Rx<LoadingMoreBase<BookItem>> itemBookRepository;

  late TabController tabController;

  // Future<void> _handleGetDatas() async {
  //   final items = await Future.wait([
  //     NeoxServices.lastAdded,
  //     MarkServices.lastAdded,
  //     RandomServices.lastAdded,
  //     CronosServices.lastAdded,
  //     PrismaServices.lastAdded,
  //     ReaperServices.lastAdded,
  //     MangaHostServices.lastAdded,
  //     ArgosService.lastAdded,
  //   ]);
  //   _neox.value = items[0];
  //   _mark.value = items[1];
  //   _random.value = items[2];
  //   _cronos.value = items[3];
  //   _prisma.value = items[4];
  //   _reaper.value = items[5];
  //   _mangaHost.value = items[6];
  //   _argos.value = items[7];
  //   _isLoading.value = false;
  // }

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
        itemBookRepository.value = NeoxRepository();

        break;
      case Scans.MARK:
        title.value = 'Mark Scans - Últimos adicionados';
        itemBookRepository.value = MarkRepository();

        break;
      case Scans.RANDOM:
        title.value = 'Random Scan - Últimos adicionados';
        itemBookRepository.value = RandomRepository();

        break;
      case Scans.CRONOS:
        title.value = 'Cronos Scans - Últimos adicionados';

        itemBookRepository.value = CronosRepository();
        break;
      case Scans.PRISMA:
        title.value = 'Prisma Scans - Últimos adicionados';

        itemBookRepository.value = PrimaRepository();
        break;
      case Scans.REAPER:
        title.value = 'Reaper Scans - Últimos adicionados';

        itemBookRepository.value = ReaperRepository();
        break;
      case Scans.MANGA_HOST:
        title.value = 'Mangá Host - Últimos adicionados';

        itemBookRepository.value = MangaHostRepository();
        break;
      case Scans.ARGOS:
        title.value = 'Argos - Popular';

        itemBookRepository.value = ArgosRepository();
        break;
    }
  }

  @override
  void onInit() {
    customCacheManager = CacheManager(
      Config(
        'Manga-Anime',
        stalePeriod: const Duration(minutes: 30),
      ),
    );
    _handleStartDownload();
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
