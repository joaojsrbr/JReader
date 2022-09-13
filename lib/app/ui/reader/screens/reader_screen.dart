// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';

import 'package:com_joaojsrbr_reader/app/core/constants/app_theme.dart';
import 'package:com_joaojsrbr_reader/app/core/constants/sort.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/html_template.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/reader_js.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/ui/reader/controlers/reader_controller.dart';
import 'package:com_joaojsrbr_reader/app/services/book_content.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:com_joaojsrbr_reader/app/stores/historic_store.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/books_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:state_change/state_change.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({
    super.key,
  });

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
    startOverlays();

    super.initState();
  }

  void startOverlays() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  ReaderJS? _js;

  List<Chapter> _chapters = RxList();
  // ValueNotifier<bool> showappbar = RxBool(false);
  bool _finished = false;
  bool _isLoading = true;
  bool _getNextCap = true;
  late Sort _sort;

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

    _finished = _index == _totalChapters - 1;
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
    _chapters = args.chapters;
    _historic = Historic(bookID: _book.id, context: context, store: store);
    _initPosition = args.position;
    _index = args.index;
    _totalChapters = args.totalChapters;
    _sort = args.sort;

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

  void endOverlays() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.bottom,
      ],
    );
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _toggleHistoric(_position);
    endOverlays();
    super.dispose();
  }

  ValueNotifier<bool> showButtons = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              key: ObjectKey(_book),
              initialUrl: _html,
              javascriptMode: JavascriptMode.unrestricted,
              backgroundColor: AppThemeData.background,
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
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                showButtons.value = !showButtons.value;
              },
              child: Container(),
            ),
            StateChange<bool>(
              notifier: showButtons,
              builder: (context, value) => AnimatedCrossFade(
                crossFadeState: value
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 650),
                reverseDuration: const Duration(milliseconds: 650),
                firstChild: const SizedBox.shrink(),
                secondChild: BackButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.manual,
                      overlays: [
                        SystemUiOverlay.bottom,
                      ],
                    );
                  },
                ),
              ),
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
          backgroundColor: AppThemeData.color(context).background,
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
