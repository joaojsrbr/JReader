// ignore_for_file: prefer_final_fields

import 'dart:isolate';
import 'dart:ui';

import 'package:com_joaojsrbr_reader/app/core/constants/ports.dart';
import 'package:com_joaojsrbr_reader/app/core/constants/sort.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/start_download.dart';
import 'package:com_joaojsrbr_reader/app/databases/downloads_db.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/models/download.dart';
import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class BookScreenController extends GetxController {
  final ReceivePort _port = ReceivePort();
  final CacheManager customCacheManager = CacheManager(
    Config(
      'cache-bookscreen',
      stalePeriod: const Duration(minutes: 10),
    ),
  );

  // late ScrollController _scrollController;
  late Rx<Sort> _sort;
  late Favorites _favorites;
  late BookItem _bookItem;

  Book? _book;
  RxList<Chapter> _chapters = RxList();
  RxMap<String, Download> _download = RxMap();
  RxBool _isLoading = RxBool(true);
  RxBool onpress = true.obs;
  // RxBool _pinnedTitle = false.obs;

  // ScrollController get scrollController => _scrollController;
  // RxBool get pinnedTitle => _pinnedTitle;
  void Function(dynamic data) get sendListening => _sendListening;
  Future<void> Function() get getDownloadItem => _getDownloadItem;
  BookItem get bookItem => _bookItem;
  ReceivePort get port => _port;
  Book? get book => _book;
  Favorites get favorites => _favorites;
  RxList<Chapter> get chapters => _chapters;
  RxBool get isLoading => _isLoading;
  Rx<Sort> get sort => _sort;
  Widget Function() get downloadAllButton => _downloadAllButton;
  RxMap<String, Download> get download => _download;
  void Function() get onPressed => _onPressed;
  void Function(Chapter chapter) get downloadOne => _downloadOne;

  set setisLoading(bool value) {
    _isLoading.value = value;
  }

  set setbook(Book? value) {
    _book = value;
  }

  set setbookItem(BookItem value) {
    _bookItem = value;
  }

  set setfavorites(Favorites value) {
    _favorites = value;
  }

  set setchapters(List<Chapter> value) {
    _chapters.value = value;
  }

  @override
  void onInit() {
    _sort = Sort.ASC.obs;
    // _scrollController = ScrollController()..addListener(_scrollListener);
    super.onInit();
  }

  @override
  void onClose() {
    // _scrollController
    //   ..removeListener(_scrollListener)
    //   ..dispose();

    IsolateNameServer.removePortNameMapping(Ports.DOWNLOAD);
    super.onClose();
  }

  void _onPressed() {
    // sort.value = value;
    onpress.value = !onpress.value;

    if (onpress.value) {
      _sort.value = Sort.ASC;
    } else {
      _sort.value = Sort.DESC;
    }
  }

  // void _scrollListener() {
  //   final double imageHeight = (70 * Get.height) / 100;

  //   if (!_pinnedTitle.value && _scrollController.offset >= imageHeight) {
  //     _pinnedTitle.value = true;
  //   } else if (_pinnedTitle.value && _scrollController.offset < imageHeight) {
  //     _pinnedTitle.value = false;
  //   }
  // }

  bool _downloadedAll() {
    if (_download.length != _chapters.length) return false;
    bool downloadedAll = false;

    for (Download item in _download.values) {
      if (!item.finished) {
        downloadedAll = false;
        break;
      }

      downloadedAll = true;
    }

    return downloadedAll;
  }

  Future<void> _getDownloadItem() async {
    final List<Download> items = await DownloadsDB.db.allByBookId(_bookItem.id);
    final Map<String, Download> download = {};

    for (Download item in items) {
      download[item.chapterId] = item;
    }

    _download.value = download;
  }

  void _sendListening(dynamic data) {
    final DownloadSend item = data as DownloadSend;
    if (item.data.bookId == _bookItem.id) {
      if (item.type == DownloadSendTypes.error) {
        _download.remove(item.data.chapterId);
      } else {
        _download.update(
          item.data.chapterId,
          (_) => item.data,
          ifAbsent: () => item.data,
        );
      }
    }
  }

  Future<void> _downloadMany() async {
    await DownloadsDB.db.insertMany(_bookItem.id, _chapters);

    _getDownloadItem();
    startDownload();
  }

  Future<void> _downloadOne(Chapter chapter) async {
    final Download item = await DownloadsDB.db.insert(
      _bookItem.id,
      chapter,
    );

    _download.update(item.chapterId, (_) => item, ifAbsent: () => item);

    startDownload();
  }

  Widget _downloadAllButton() {
    if (_downloadedAll()) {
      return const IconButton(
        onPressed: null,
        icon: Icon(Icons.download_done_rounded),
      );
    }

    RxBool downloading = false.obs;
    for (Download item in _download.values) {
      if (!item.finished) {
        downloading.value = true;
        break;
      }
    }

    return Obx(
      () => IconButton(
        icon: downloading.value
            ? const Icon(Icons.downloading_rounded)
            : const Icon(Icons.download_rounded),
        onPressed: _isLoading.value ? null : _downloadMany,
      ),
    );
  }
}
