import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:com_joaojsrbr_reader/app/core/constants/providers.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/start_download.dart';
import 'package:com_joaojsrbr_reader/app/databases/downloads_db.dart';
import 'package:com_joaojsrbr_reader/app/global_variable.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/repository/repository.dart';
import 'package:com_joaojsrbr_reader/app/services/notification/notification_service.dart';
import 'package:com_joaojsrbr_reader/app/services/version/version_service.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/controlers/hashset_controller.dart';
import 'package:com_joaojsrbr_reader/app/widgets/app_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:pub_semver/pub_semver.dart';
import 'package:workmanager/workmanager.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  final CacheManager customCacheManager = CacheManager(
    Config(
      'Manga-Image-c',
      stalePeriod: const Duration(days: 2),
    ),
  );

  void onChange(List<String> filter) => result.scan(filter.single, repository);

  List<String> filters = Providers.values.strings();

  final VersionService _localStorageService = Get.find<VersionService>();
  final NotificationsService _notificationsService =
      Get.find<NotificationsService>();
  late Repository repository;

  HashSetController hashset = HashSetController();

  ValueNotifier<Providers> scans = ValueNotifier(Providers.NEOX);
  ValueNotifier<bool> inrefresh = ValueNotifier(true);
  ValueNotifier<int> destinationSelected = ValueNotifier(0);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  late ValueNotifier<LoadingMoreBase<BookItem>> result;
  late ScrollController scrollController;

  late TabController tabController;

  Future<void> _handleStartDownload() async {
    final items = await DownloadsDB.db.notFinished;
    if (items.isNotEmpty) startDownload();
  }

  void onDestinationSelected(int value) {
    destinationSelected.value = value;
    tabController.animateTo(value, curve: Curves.ease);
  }

  @override
  void onInit() async {
    repository = Repository();
    result = ValueNotifier(repository.lista[0]);
    _handleStartDownload();

    scrollController = ScrollController();

    tabController = TabController(
      length: 2,
      animationDuration: const Duration(milliseconds: 550),
      vsync: this,
    );

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.onInit();
  }

  Future<void> notificationManga() async {
    await Workmanager().registerPeriodicTask(
      GlobalVariable.mangaNotificationKey,
      GlobalVariable.mangaNotificationKey,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.keep,
      backoffPolicyDelay: const Duration(seconds: 8),
      backoffPolicy: BackoffPolicy.linear,
      initialDelay: Duration.zero,
      frequency: const Duration(minutes: 20),
    );
  }

  @override
  void onReady() async {
    Version? newRelease = await _localStorageService.checkUpdate();
    if (newRelease != null) {
      appUpdateDialog(newRelease);
    }

    await notificationManga();

    await awesomeNotifications.isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await _notificationsService.dilog;
        }
      },
    );

    super.onReady();
  }

  Future<void> onRefresh() async {
    inrefresh.value = false;
    await result.value.refresh(true);
    inrefresh.value = true;
  }

  @override
  void onClose() {
    result.dispose();
    scrollController.dispose();
    tabController.dispose();
    super.onClose();
  }
}
