// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';

import 'package:com_joaojsrbr_reader/app/core/constants/sort.dart';
import 'package:com_joaojsrbr_reader/app/core/themes/colors.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/html_template.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/reader_js.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/modules/book/controlers/book_screen_controller.dart';
import 'package:com_joaojsrbr_reader/app/modules/reader/controlers/reader_controller.dart';
import 'package:com_joaojsrbr_reader/app/services/book_content.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:com_joaojsrbr_reader/app/store/historic_store.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/books_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen>
    with WidgetsBindingObserver {
  final String _html = Uri.dataFromString(
    htmlTemplate,
    mimeType: 'text/html',
    encoding: Encoding.getByName('utf-8'),
  ).toString();

  late int _index;
  late BookItem _book;
  late Historic _historic;
  late int _totalChapters;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    super.initState();
  }

  ReaderJS? _js;

  RxList<Chapter> _chapters = RxList();
  RxBool showappbar = RxBool(false);
  bool _finished = false;
  bool _isLoading = true;
  bool _getNextCap = true;

  String? _position;
  double? _initPosition;

  void _toggleHistoric(String? value) {
    if (value == null || !value.contains(',,')) return;

    final List<String> values = value.split(',,');
    final int index = int.parse(values.first);
    final double position = double.parse(values.last);

    _historic.toggleHistoric(_chapters[index].id, position);
  }

  Future<void> _getContent() async {
    final Chapter chapter = _chapters[_index];

    List<String> content = await BooksPath.getContent(_book.id, chapter.id);
    if (content.isEmpty) content = await bookContent(chapter.url);

    await _js!.insertContent(content, _index, chapter.name);

    if (kDebugMode) {
      print(_index);
    }
    switch (_sort) {
      case Sort.DESC:
        _finished = _index == 0;
        break;
      case Sort.ASC:
        _finished = _index == _totalChapters - 1;
        break;
    }

    // _finished = _index == _totalChapters;
    if (_finished) await _js!.finishedChapters();

    _getNextCap = false;
  }

  Future<void> _onLoad(JavascriptMessage message) async {
    if (!_isLoading) return;
    _isLoading = false;

    if (_initPosition != null) {
      final bool continueByHistoric = await _continueByHistoric();
      if (continueByHistoric) await _js!.scrollTo(_initPosition!);
    }

    await _js!.removeLoading();
  }

  late Sort _sort;

  void _onNext(JavascriptMessage message) {
    if (_finished || _getNextCap) return;
    _toggleHistoric(_position);

    switch (_sort) {
      case Sort.DESC:
        _index = _index - 1;
        break;
      case Sort.ASC:
        _index = _index + 1;
        break;
    }
    // _index = _index - 1;
    _getContent();
  }

  void _onFinished(JavascriptMessage message) {
    _toggleHistoric(message.message);
  }

  void _onPosition(JavascriptMessage message) => _position = message.message;

  @override
  void didChangeDependencies() {
    final HistoricStore store = Provider.of<HistoricStore>(context);
    final args = ModalRoute.of(context)!.settings.arguments as ReaderArguments;

    _book = args.book;
    _chapters.value = args.chapters;
    _historic = Historic(bookID: _book.id, context: context, store: store);
    _initPosition = args.position;
    _sort = Get.find<BookScreenController>().sort.value;
    _index = args.index;
    _totalChapters = args.totalChapters;

    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        _toggleHistoric(_position);
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        _toggleHistoric(_position);
        break;
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _toggleHistoric(_position);
    showappbar.close();
    _chapters.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => WebView(
                key: ObjectKey(_chapters[_index].url),
                initialUrl: _html,
                javascriptMode: JavascriptMode.unrestricted,
                backgroundColor: CustomColors.background,
                gestureNavigationEnabled: true,
                onWebViewCreated: (controller) {
                  _js = ReaderJS(controller);
                },
                onPageFinished: (_) => _getContent(),
                javascriptChannels: {
                  JavascriptChannel(
                    name: 'onLoad',
                    onMessageReceived: _onLoad,
                  ),
                  JavascriptChannel(
                    name: 'onNext',
                    onMessageReceived: _onNext,
                  ),
                  JavascriptChannel(
                    name: 'onFinished',
                    onMessageReceived: _onFinished,
                  ),
                  JavascriptChannel(
                    name: 'onPosition',
                    onMessageReceived: _onPosition,
                  ),
                },
              ),
            ),

            // ClipRRect(
            //   borderRadius: const BorderRadius.only(
            //     bottomLeft: Radius.circular(25),
            //     bottomRight: Radius.circular(25),
            //   ),
            //   child: Obx(
            //     () => AnimatedContainer(
            //       height: showappbar.value ? kToolbarHeight * 1.05 : 0,
            //       width: double.infinity,
            //       duration: const Duration(milliseconds: 450),
            //       decoration: BoxDecoration(
            //         color: Theme.of(context)
            //             .colorScheme
            //             .background
            //             .withOpacity(0.55),
            //       ),
            //       curve: Curves.linear,
            //       padding: const EdgeInsets.only(left: 5),
            //       child: Row(
            //         mainAxisSize: MainAxisSize.max,
            //         children: [
            //           Flexible(
            //             flex: 1,
            //             child: Container(
            //               alignment: Alignment.centerLeft,
            //               child: const BackButton(),
            //             ),
            //           ),
            //           Flexible(
            //             flex: 6,
            //             child: Container(
            //               alignment: Alignment.centerLeft,
            //               height: 65,
            //               child: Obx(
            //                 () => Text(_chapters[_index].name),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 50,
              width: 50,
              child: BackButton(),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _continueByHistoric() async {
    final bool? continueByHistoric = await showDialog<bool>(
      context: context,
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
}
