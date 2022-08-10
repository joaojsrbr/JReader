// ignore_for_file: unused_field, prefer_final_fields

import 'package:com_joaojsrbr_reader/app/core/constants/sort.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/books_path.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/services/book_content.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ReaderController extends GetxController {
  void Function()? previousScroll;
  void Function()? nextScroll;
  final CacheManager cacheManager = DefaultCacheManager();
  final RxInt currentIndex = 0.obs;

  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;
  late ScrollController scrollController;
  late TransformationController transformationController;
  void _listen() {}

  void _listen2() {}

  @override
  void onInit() {
    scrollController = ScrollController()..addListener(_listen);
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create()
      ..itemPositions.addListener(_listen2);
    transformationController = TransformationController();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController
      ..removeListener(_listen)
      ..dispose();
    itemPositionsListener.itemPositions.removeListener(_listen2);

    super.onClose();
  }

  @override
  void onReady() async {
    final Chapter chapter = _chapters[_index];

    content.value = await BooksPath.getContent(_book.id, chapter.id);
    if (content.isEmpty) content.value = await bookContent(chapter.url);

    super.onReady();
  }

  late int _index;
  late BookItem _book;
  late List<Chapter> _chapters;
  late Historic _historic;
  late int _totalChapters;
  late Sort _sort;

  bool _finished = false;
  bool _isLoading = true;
  bool _getNextCap = true;
  String? _position;
  double? _initPosition;
  RxList<String> content = <String>[].obs;

  // late List<String> content;

  BookItem get book => _book;
  // RxList<String> get content => _content;
  List<Chapter> get chapters => _chapters;
  int get index => _index;
  // Future<List<String>> Function() get getContent => _getContent;

  set setindex(int value) {
    _index = value;
  }

  set setinitPosition(double? value) {
    _initPosition = value;
  }

  set setsort(Sort value) {
    _sort = value;
  }

  set setbook(BookItem value) {
    _book = value;
  }

  set setchapters(List<Chapter> value) {
    _chapters = value;
  }

  set sethistoric(Historic value) {
    _historic = value;
  }

  set settotalChapters(int value) {
    _totalChapters = value;
  }
}

class ReaderArguments {
  final int index;
  final BookItem book;
  final List<Chapter> chapters;
  final double? position;
  final int totalChapters;

  const ReaderArguments({
    required this.index,
    required this.totalChapters,
    required this.book,
    required this.chapters,
    this.position,
  });
}
