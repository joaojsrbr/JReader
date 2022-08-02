import 'dart:convert';
import 'dart:io';

import 'package:com_joaojsrbr_reader/app/core/themes/colors.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/html_template.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/reader_js.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/services/book_content.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:com_joaojsrbr_reader/app/store/historic_store.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/books_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({Key? key}) : super(key: key);

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
  late List<Chapter> _chapters;
  late Historic _historic;
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();

    super.initState();
  }

  ReaderJS? _js;

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

    _finished = _index == 0;
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

    _index = _index - 1;
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
    _index = args.index;
    _chapters = args.chapters;
    _historic = Historic(bookID: _book.id, context: context, store: store);
    _initPosition = args.position;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
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

class ReaderArguments {
  final int index;
  final BookItem book;
  final List<Chapter> chapters;
  final double? position;

  const ReaderArguments({
    required this.index,
    required this.book,
    required this.chapters,
    this.position,
  });
}
