import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:pub_semver/pub_semver.dart';

import 'package:com_joaojsrbr_reader/app/core/constants/providers.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/start_download.dart';
import 'package:com_joaojsrbr_reader/app/databases/downloads_db.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/repository/repository_export.dart';
import 'package:com_joaojsrbr_reader/app/services/version/version_service.dart';
import 'package:com_joaojsrbr_reader/app/widgets/app_update_dialog.dart';

class HomeController extends GetxController
    with GetTickerProviderStateMixin, StateMixin<LoadingMoreBase<BookItem>> {
  final CacheManager customCacheManager = CacheManager(
    Config(
      'Manga-Image-c',
      stalePeriod: const Duration(minutes: 30),
    ),
  );

  final VersionService _localStorageService = Get.find<VersionService>();

  // RxBool isLoading = true.obs;
  RxString title = 'Neox - Últimos adicionados'.obs;
  Rx<Providers> scans = Providers.NEOX.obs;
  RxBool inrefresh = true.obs;

  RxInt destinationSelected = 0.obs;

  late ScrollController scrollController;
  late LoadingMoreBase<BookItem> itemBookRepository;
  late List<LoadingMoreBase<BookItem>> repositories;
  late TabController tabController;

  Future<void> repositoriesInit() async {
    repositories = <LoadingMoreBase<BookItem>>[
      NeoxRepository(),
      MarkRepository(),
      RandomRepository(),
      CronosRepository(),
      PrimaRepository(),
      ReaperRepository(),
      MangaHostRepository(),
      ArgosRepository.popular(),
      OlympusRepository(),
    ];

    itemBookRepository = repositories[0];
    change(itemBookRepository, status: RxStatus.success());
  }

  Future<void> _handleStartDownload() async {
    final items = await DownloadsDB.db.notFinished;
    if (items.isNotEmpty) startDownload();
  }

  void onDestinationSelected(int value) {
    destinationSelected.value = value;
    tabController.animateTo(
      value,
      curve: Curves.fastOutSlowIn,
      // curve: Curves.ease,
    );
  }

  void onSelected(Providers value) {
    scans.value = value;
    switch (scans.value) {
      case Providers.NEOX:
        title.value = '${scans.value.string} - Últimos adicionados';
        itemBookRepository = repositories[0];
        change(itemBookRepository, status: RxStatus.success());
        break;
      case Providers.MARK:
        title.value = '${scans.value.string}  - Últimos adicionados';
        itemBookRepository = repositories[1];
        change(itemBookRepository, status: RxStatus.success());
        break;
      case Providers.RANDOM:
        title.value = '${scans.value.string} - Últimos adicionados';
        itemBookRepository = repositories[2];
        change(itemBookRepository, status: RxStatus.success());
        break;
      case Providers.CRONOS:
        title.value = '${scans.value.string} - Últimos adicionados';
        change(itemBookRepository, status: RxStatus.success());
        itemBookRepository = repositories[3];
        break;
      case Providers.PRISMA:
        title.value = '${scans.value.string} - Últimos adicionados';
        itemBookRepository = repositories[4];
        change(itemBookRepository, status: RxStatus.success());
        break;
      case Providers.REAPER:
        title.value = '${scans.value.string} - Últimos adicionados';
        itemBookRepository = repositories[5];
        change(itemBookRepository, status: RxStatus.success());
        break;
      case Providers.MANGA_HOST:
        title.value = '${scans.value.string} - Últimos adicionados';
        itemBookRepository = repositories[6];
        change(itemBookRepository, status: RxStatus.success());
        break;
      case Providers.ARGOS:
        title.value = '${scans.value.string} - Popular';
        itemBookRepository = repositories[7];
        change(itemBookRepository, status: RxStatus.success());
        break;
      case Providers.OLYMPUS:
        title.value = '${scans.value.string} - Últimos adicionados';
        itemBookRepository = repositories[8];
        change(itemBookRepository, status: RxStatus.success());
        break;
    }
  }

  @override
  void onInit() async {
    _handleStartDownload();
    FlutterNativeSplash.remove();
    scrollController = ScrollController();
    tabController = TabController(
      length: 2,
      animationDuration: const Duration(milliseconds: 400),
      vsync: this,
    );
    await repositoriesInit();

    super.onInit();
  }

  @override
  void onReady() async {
    Version? newRelease = await _localStorageService.checkUpdate();
    if (newRelease != null) {
      appUpdateDialog(newRelease);
    }

    super.onReady();
  }

  Key stringkey(Key? key, String name) {
    return Key('#$name-$key');
  }

  Key pageStorageKey(Key? key, String name) {
    return ObjectKey('#$name-$key');
  }

  Future<void> onRefresh() async {
    RxStatus.loading();
    await itemBookRepository.refresh(true);
    RxStatus.success();
  }

  @override
  void onClose() {
    itemBookRepository.dispose();
    scrollController.dispose();
    tabController.dispose();
    super.onClose();
  }
}
