// ignore_for_file: prefer_final_fields

import 'package:com_joaojsrbr_reader/app/core/constants/sort.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/books_path.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/services/book_content.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReaderController extends GetxController with WidgetsBindingObserver {
  void show() {
    if (!showAppbar.value || !showbotton.value) {
      showbotton.value = true;
      showAppbar.value = true;
    }
  }

  void hide() {
    if (showAppbar.value || showbotton.value) {
      showbotton.value = false;
      showAppbar.value = false;
    }
  }

  void _listener() {
    _position.value = scrollController.offset;
    // print(scrollController.offset);
    disablebotton.value = (_chapters[_index].id == _chapters.first.id);
    // final direction = scrollController.position.userScrollDirection;
    if (scrollController.position.pixels >= 150) {
      hide();
    } else {
      show();
    }
    if (scrollController.position.extentAfter <= 0) {
      _end();
    }
  }

  void _end() async {
    if (!_finished.value) {
      await Future.delayed(
        const Duration(milliseconds: 500),
      );
      // await scrollController.animateTo(0,
      //     duration: const Duration(milliseconds: 150), curve: Curves.linear);
      // _onNext();
      showbotton.value = true;
      showAppbar.value = true;
    } else {
      titleEnd.value = 'Não há mais capítulos no memento.';
      disablebotton.value = false;
      showbotton.value = true;
    }
  }

  @override
  void onInit() {
    _scrollController = ScrollController()..addListener(_listener);
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }

  @override
  void onClose() {
    _toggleHistoric(_position.value);
    _scrollController
      ..removeListener(_listener)
      ..dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.onClose();
  }

  @override
  void onReady() async {
    _getContent();

    if (_finished.value) {
      _onFinished();
    }
    _onLoad();

    super.onReady();
  }

  Future<void> _onLoad() async {
    // if (!_isLoading) return;
    // _isLoading = false;

    if (_initPosition != null) {
      final bool continueByHistoric = await _continueByHistoric();
      if (continueByHistoric) {
        await scrollController.animateTo(_initPosition!,
            duration: const Duration(milliseconds: 450), curve: Curves.linear);
      }
    }
  }

  Future<bool> _continueByHistoric() async {
    // print(context.value);
    final bool? continueByHistoric = await showDialog<bool>(
      context: context.value,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text('Continuar de onde parou'),
          content: Text(
            'Você já começou a ler esse livro, desejá continuar a leitura de onde parou?',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 14,
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('NÃO'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('SIM'),
            ),
          ],
        );
      },
    );

    return continueByHistoric ?? false;
  }

  void _onFinished() {
    _toggleHistoric(scrollController.offset - 200);
  }

  void _onPrevius() {
    if (_index == 0 || _finished.value == true) return;
    // if (_finished || _getNextCap) return;
    _toggleHistoric(scrollController.offset);
    switch (_sort) {
      case Sort.DESC:
        _index = _index + 1;
        break;
      case Sort.ASC:
        _index = _index - 1;
        break;
    }

    _getContent();
  }

  void _onNext({bool button = false}) {
    if (button == false) {
      if (_finished.value || _getNextCap) return;
      _toggleHistoric(scrollController.offset);

      switch (_sort) {
        case Sort.DESC:
          _index = _index - 1;
          break;
        case Sort.ASC:
          _index = _index + 1;
          break;
      }
      // _index = _index - 1;
      // _getContent();
    } else {
      _toggleHistoric(scrollController.offset);

      switch (_sort) {
        case Sort.DESC:
          if (_chapters[_index].id.contains(_totalChapters.toString())) {
            _index = _index + 1;
            return;
          } else {
            _index = _index - 1;
          }
          break;
        case Sort.ASC:
          _index = _index + 1;
          break;
      }
      // _index = _index - 1;

    }
    _getContent();
  }

  void _toggleHistoric(double value) {
    // if (value == null) return;

    // final int index = int.parse(values.first);
    // final double position = double.parse(value);

    _historic.toggleHistoric(_chapters[_index].id, value);
  }

  Future<void> _getContent() async {
    content.clear();
    // final Chapter chapter = _chapters[_index];

    // List<String> content = await BooksPath.getContent(_book.id, chapter.id);
    // if (content.isEmpty) content = await bookContent(chapter.url);

    final Chapter chapter = _chapters[_index];
    title.value = chapter.name;

    for (var e in await BooksPath.getContent(_book.id, chapter.id)) {
      // _content.value = await BooksPath.getContent(_book.id, chapter.id);
      content.add(e);
    }

    if (content.isEmpty) {
      // content.value = await bookContent(chapter.url);
      for (var i in await bookContent(chapter.url)) {
        // precacheImage(
        //     CachedNetworkImageProvider(i, cacheKey: i), context.value);
        content.add(i);
      }
    }

    // if (kDebugMode) {
    //   print(_index);
    // }

    switch (_sort) {
      case Sort.DESC:
        _finished.value = (_index == 0);
        break;
      case Sort.ASC:
        _finished.value = (_index == _totalChapters);

        break;
    }

    // init.value = _finished.value;

    // _finished = _index == _totalChapters;

    _getNextCap = false;
  }

  Size size(BuildContext context) =>
      Size(context.width / 6.25, kToolbarHeight * 1.05);

  late int _index;
  late BookItem _book;
  late List<Chapter> _chapters;
  late Historic _historic;
  late int _totalChapters;
  late Sort _sort;
  late ScrollController _scrollController;
  // late UnmodifiableListView<String> _viewcontent =
  //     UnmodifiableListView<String>(_content);

  Rx<BuildContext> _context = Get.context!.obs;
  RxBool _showAppbar = true.obs;
  RxBool _disablebotton = false.obs;
  RxBool _showbotton = true.obs;
  RxString _titleEnd = ''.obs;
  RxString _title = ''.obs;
  RxBool _finished = false.obs;
  bool _getNextCap = true;
  RxDouble _position = 0.0.obs;
  double? _initPosition;
  RxList<String> content = <String>[].obs;

  // List<String> get content => _viewcontent;
  ScrollController get scrollController => _scrollController;
  RxString get title => _title;
  RxString get titleEnd => _titleEnd;
  RxBool get disablebotton => _disablebotton;
  RxBool get showAppbar => _showAppbar;
  RxBool get showbotton => _showbotton;
  Rx<BuildContext> get context => _context;
  RxBool get finished => _finished;
  BookItem get book => _book;
  int get index => _index;
  void Function() get onPrevius => _onPrevius;
  void Function({bool button}) get onNext => _onNext;
  Future<void> Function() get getContent => _getContent;
  List<Chapter> get chapters => _chapters;
  void Function(double) get toggleHistoric => _toggleHistoric;

  set setindex(int value) {
    _index = value;
  }

  set setinitPosition(double? value) {
    _initPosition = value;
  }

  set setcontext(BuildContext value) {
    context.value = value;
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        _toggleHistoric(scrollController.offset);
        // print('inactive');
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        _toggleHistoric(scrollController.offset);
        // print('detached');
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  // @override
  // void onDetached() {
  //   _toggleHistoric(scrollController.offset);
  // }

  // @override
  // void onInactive() {
  //   _toggleHistoric(scrollController.offset);
  // }

  // @override
  // void onPaused() {}

  // @override
  // void onResumed() {}
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
