// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_final_fields

import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com_joaojsrbr_reader/app/core/constants/app_theme.dart';
import 'package:com_joaojsrbr_reader/app/core/constants/ports.dart';
import 'package:com_joaojsrbr_reader/app/core/constants/sort.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/start_download.dart';
import 'package:com_joaojsrbr_reader/app/databases/downloads_db.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/models/download.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/book_info.dart';
import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:com_joaojsrbr_reader/app/stores/favorites_store.dart';
import 'package:com_joaojsrbr_reader/app/stores/historic_store.dart';
import 'package:com_joaojsrbr_reader/app/ui/about/screens/about_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/book/widgets/select_title.dart';
import 'package:com_joaojsrbr_reader/app/ui/reader/controlers/reader_controller.dart';
import 'package:com_joaojsrbr_reader/app/widgets/accent_subtitle.dart';
import 'package:com_joaojsrbr_reader/app/widgets/animated_fade_out_in.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';
import 'package:com_joaojsrbr_reader/app/widgets/sinopse.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:state_change/state_change.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  static CacheManager customCacheManager = CacheManager(
    Config(
      'cache-bookscreen',
      stalePeriod: const Duration(minutes: 10),
    ),
  );
  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final ReceivePort _port = ReceivePort();

  late BookItem _bookItem;
  late Favorites _favorites;

  late ValueNotifier<Sort> _sort;
  bool onpress = false;

  Book? _book;
  List<Chapter> _chapters = [];
  ValueNotifier<bool> _isLoading = ValueNotifier(true);
  List<Chapter> _displayChapters = [];
  Map<String, Download> _download = {};

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

    setState(() => _download = download);
  }

  // void _changeOrder() {
  //   if (_orderBy == Order.DESC) {
  //     setState(() {
  //       _orderBy = Order.ASC;
  //       _displayChapters = _chapters.reversed.toList();
  //     });
  //   } else {

  //       _sort.value = Order.DESC;
  //       _displayChapters = _chapters;

  //   }

  Future<void> _downloadOne(Chapter chapter) async {
    final Download item = await DownloadsDB.db.insert(
      _bookItem.id,
      chapter,
    );

    setState(() {
      _download.update(item.chapterId, (_) => item, ifAbsent: () => item);
    });
    startDownload();
  }

  void _sendListening(dynamic data) {
    final DownloadSend item = data as DownloadSend;
    if (item.data.bookId == _bookItem.id) {
      if (item.type == DownloadSendTypes.error) {
        setState(() => _download.remove(item.data.chapterId));
      } else {
        setState(() {
          _download.update(
            item.data.chapterId,
            (_) => item.data,
            ifAbsent: () => item.data,
          );
        });
      }
    }
  }

  void _onPressed() {
    // sort.value = value;
    onpress = !onpress;

    if (onpress) {
      _sort.value = Sort.ASC;
    } else {
      _sort.value = Sort.DESC;
    }
  }

  Widget _downloadAllButton() {
    if (_downloadedAll()) {
      return const IconButton(
        onPressed: null,
        icon: Icon(Icons.download_done_rounded),
      );
    }

    bool downloading = false;
    for (Download item in _download.values) {
      if (!item.finished) {
        downloading = true;
        break;
      }
    }

    Future<void> downloadMany() async {
      await DownloadsDB.db.insertMany(_bookItem.id, _displayChapters);

      await _getDownloadItem();
      await startDownload();
    }

    return IconButton(
      icon: downloading
          ? const Icon(Icons.downloading_rounded)
          : const Icon(Icons.download_rounded),
      onPressed: _isLoading.value ? null : downloadMany,
    );
  }

  // void listener() {
  //   if (_scroll.position.pixels > 200) {
  //     showButtons.value = false;
  //   } else if (_scroll.position.pixels < 200) {
  //     showButtons.value = true;
  //   }
  // }

  void startOverlays() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.bottom,
      ],
    );
  }

  void endOverlays() async {
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  @override
  void initState() {
    startOverlays();
    _sort = ValueNotifier(Sort.DESC);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final FavoritesStore store = Provider.of<FavoritesStore>(context);
    // state.controller?.bookItem =
    //     ModalRoute.of(context)!.settings.arguments as BookItem;
    _bookItem = ModalRoute.of(context)!.settings.arguments as BookItem;

    _favorites = Favorites(book: _bookItem, store: store, context: context);

    IsolateNameServer.registerPortWithName(_port.sendPort, Ports.DOWNLOAD);

    // _port.listen(_sendListening);

    _getDownloadItem();

    bookInfo(_bookItem.url, _bookItem.name).then(
      (value) {
        if (!mounted) return;
        setState(() {
          _book = value;
          _chapters = value?.chapters ?? [];
        });
        _isLoading.value = false;
      },
    ).catchError(
      (e) {
        if (!mounted) return;
        final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Algo deu errado ao obter as informações do ${_bookItem.tag ?? 'livro'}.',
            ),
          ),
        );
      },
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(Ports.DOWNLOAD);
    endOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Stack(
        children: [
          MyHomePage(
            bookItem: _bookItem,
            chapters: _chapters,
            sendListening: _sendListening,
            sort: _sort,
            getDownloadItem: _getDownloadItem,
            book: _book,
            download: _download,
            downloadAllButton: _downloadAllButton,
            downloadOne: _downloadOne,
            onPressed: _onPressed,
            isLoading: _isLoading,
            cacheManager: BookScreen.customCacheManager,
            favorites: _favorites.button,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top * 1.12,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InkWellApp extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;

  final BorderRadius borderRadius;

  const InkWellApp(
      {Key? key,
      required this.onTap,
      required this.child,
      this.borderRadius = BorderRadius.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            borderRadius: borderRadius,
            child: InkWell(
              borderRadius: borderRadius,
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final Widget Function() downloadAllButton;
  final void Function() onPressed;
  final ValueNotifier<Sort> sort;
  Delegate({
    required this.downloadAllButton,
    required this.onPressed,
    required this.sort,
  });
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      color: AppThemeData.color(context).background,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Flexible(
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'Capítulos',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Center(
                  //   child: Field(
                  //     height: 30,
                  //     width: 90,
                  //     isSearching: ValueNotifier(false),
                  //   ),
                  // ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onPressed,
                        icon: StateChange<Sort>(
                          notifier: sort,
                          builder: (context, sort) => AnimatedFadeOutIn<Sort>(
                            data: sort,
                            curve: Curves.easeInCubic,
                            reverseCurve: Curves.easeOutCubic,
                            builder: (data) {
                              late Widget widget;
                              switch (data) {
                                case Sort.DESC:
                                  widget = const Icon(
                                    Icons.arrow_drop_up_rounded,
                                    size: 30,
                                  );
                                  break;
                                case Sort.ASC:
                                  widget = const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    size: 30,
                                  );
                                  break;
                              }
                              return Center(child: widget);
                            },
                          ),
                        ),
                      ),
                      downloadAllButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class MyHomePage extends StatefulWidget {
  final BookItem bookItem;
  final Book? book;
  final ValueNotifier<Sort> sort;
  final ValueNotifier<bool> isLoading;
  final List<Chapter> chapters;
  final Map<String, Download> download;
  final Widget Function() downloadAllButton;
  final void Function() onPressed;
  final Future<void> Function(Chapter chapter) downloadOne;
  final Future<void> Function() getDownloadItem;
  final Widget favorites;
  final BaseCacheManager? cacheManager;
  final void Function(dynamic) sendListening;
  const MyHomePage({
    Key? key,
    required this.bookItem,
    this.book,
    required this.sort,
    required this.isLoading,
    required this.chapters,
    required this.download,
    required this.downloadAllButton,
    required this.onPressed,
    required this.downloadOne,
    required this.getDownloadItem,
    required this.favorites,
    this.cacheManager,
    required this.sendListening,
  }) : super(key: key);

  static final DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late double _height;

  late Size imageSize;

  @override
  void initState() {
    imageSize = const Size(double.infinity, 500);
    widget.isLoading.addListener(listener);
    _height = 10;

    super.initState();
  }

  final ReceivePort _port = ReceivePort();
  @override
  void didChangeDependencies() {
    _port.listen(widget.sendListening);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.isLoading.removeListener(listener);

    super.dispose();
  }

  void listener() {
    if (kDebugMode) {
      setState(() {});
      print('tests');
    }
  }

  @override
  Widget build(BuildContext context) {
    final HistoricStore store = Provider.of<HistoricStore>(context);

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (dr) {
        if (!widget.isLoading.value) {
          _height = dr.extent > 0.6
              ? (widget.book?.categories.isEmpty ??
                      false || widget.book?.sinopse.isEmpty == null)
                  ? 80
                  : 300
              : 0.0;

          if (kDebugMode) {
            print('fl $_height');
          }
          return true;
        } else {
          return false;
        }
      },
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            child: CachedNetworkImage(
              height: imageSize.height,
              imageUrl: widget.bookItem.imageURL2 ?? widget.bookItem.imageURL,
              cacheKey: widget.bookItem.imageURL2 ?? widget.bookItem.imageURL,
              width: imageSize.width,
              fit: BoxFit.cover,
              placeholder: (context, url) => Image.memory(kTransparentImage),
              filterQuality: FilterQuality.high,
              cacheManager: widget.cacheManager,
              httpHeaders: widget.bookItem.headers,
            ),
          ),
          DraggableScrollableSheet(
            minChildSize: 0.48,
            initialChildSize: 0.58,
            maxChildSize: 0.9,
            builder: (BuildContext context, ScrollController scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22.0),
                ),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      padding: EdgeInsets.only(
                        top: _height == 0 ? 20 : _height,
                        left: 12,
                        right: 12,
                      ),
                      curve: Curves.ease,
                      duration: _height == 300 || _height == 80
                          ? const Duration(milliseconds: 750)
                          : const Duration(milliseconds: 2500),
                      color: Colors.black,
                      child: CustomScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          SliverPersistentHeader(
                            pinned: true,
                            floating: true,
                            delegate: Delegate(
                              sort: widget.sort,
                              downloadAllButton: widget.downloadAllButton,
                              onPressed: widget.onPressed,
                            ),
                          ),
                          StateChange<bool>(
                            notifier: widget.isLoading,
                            builder: (context, load) => load
                                ? const SliverFillRemaining(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : SliverPadding(
                                    padding: const EdgeInsets.only(top: 8),
                                    sliver: SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          return StateChange<Sort>(
                                            notifier: widget.sort,
                                            builder: (context, sort) {
                                              final Chapter chapter =
                                                  (sort == Sort.DESC)
                                                      ? widget.chapters[index]
                                                      : widget.chapters.reversed
                                                          .toList()[index];

                                              final Download? downloadChapter =
                                                  widget.download[chapter.id];

                                              return ListTile(
                                                title: Text(
                                                  chapter.name,
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 32,
                                                ),
                                                trailing: Observer(
                                                  builder: ((context) {
                                                    final book = store.historic[
                                                        widget.bookItem.id];
                                                    final bool read =
                                                        book?.containsKey(
                                                                chapter.id) ??
                                                            false;

                                                    final List<Widget>
                                                        children = [];

                                                    if (read) {
                                                      children.add(
                                                        const Icon(
                                                          Icons.visibility,
                                                        ),
                                                      );
                                                    }
                                                    if (downloadChapter
                                                            ?.finished ==
                                                        true) {
                                                      children.add(
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                      );
                                                      children.add(
                                                        const Icon(
                                                          Icons
                                                              .download_done_rounded,
                                                        ),
                                                      );
                                                    } else if (downloadChapter !=
                                                        null) {
                                                      children.add(
                                                        const SizedBox(
                                                          width: 16,
                                                        ),
                                                      );
                                                      children.add(
                                                        const Icon(
                                                          Icons
                                                              .downloading_rounded,
                                                        ),
                                                      );
                                                    }

                                                    return Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: children,
                                                    );
                                                  }),
                                                ),
                                                onTap: () async {
                                                  await Get.toNamed(
                                                    RoutesName.READER,
                                                    arguments: ReaderArguments(
                                                      sort: sort,
                                                      totalChapters: int.parse(
                                                        widget.book
                                                                ?.totalChapters ??
                                                            '0',
                                                      ),
                                                      book: widget.bookItem,
                                                      chapters:
                                                          (sort == Sort.DESC)
                                                              ? widget.chapters
                                                              : widget.chapters
                                                                  .reversed
                                                                  .toList(),
                                                      index: index,
                                                      position: store.historic[
                                                          widget.bookItem
                                                              .id]?[chapter.id],
                                                    ),
                                                  );
                                                  widget.getDownloadItem();
                                                },
                                                onLongPress: () async {
                                                  // final downloaded =
                                                  // downloadChapter?.finished == true;
                                                  // final downloading = downloadChapter != null;

                                                  // if (downloaded || downloading) return;
                                                  // if (downloading) return;

                                                  final String? action =
                                                      await showModalBottomSheet<
                                                          String>(
                                                    context: context,
                                                    builder: (context) {
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ListTile(
                                                            title: const Text(
                                                              'Baixar capítulo',
                                                            ),
                                                            leading: const Icon(
                                                              Icons.download,
                                                            ),
                                                            onTap: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(
                                                                        'down'),
                                                          ),
                                                          ListTile(
                                                            onLongPress: () {},
                                                            title: const Text(
                                                                'Deletar capítulo'),
                                                            leading: const Icon(
                                                                Icons
                                                                    .visibility),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(
                                                                'deletar',
                                                              );
                                                            },
                                                          ),
                                                          ListTile(
                                                            onLongPress: () {},
                                                            title: const Text(
                                                              'Marca como visto',
                                                            ),
                                                            leading: const Icon(
                                                              Icons.visibility,
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(
                                                                'visto',
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                    backgroundColor: Get.theme
                                                        .colorScheme.background,
                                                    useRootNavigator: true,
                                                    constraints:
                                                        const BoxConstraints(
                                                      minHeight: 90,
                                                    ),
                                                  );

                                                  if (action == 'down') {
                                                    widget.downloadOne(chapter);
                                                  } else if (action ==
                                                      'visto') {
                                                    Historic(
                                                      bookID:
                                                          widget.bookItem.id,
                                                      context: context,
                                                      store: store,
                                                    ).toggleHistoric(
                                                        (sort == Sort.DESC)
                                                            ? widget
                                                                .chapters[index]
                                                                .id
                                                            : widget.chapters
                                                                .reversed
                                                                .toList()[index]
                                                                .id,
                                                        0.0);
                                                  } else if (action ==
                                                      'deletar') {
                                                    setState(() {
                                                      DownloadsDB.db.remove(
                                                          widget.bookItem.id);
                                                    });
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                        childCount: widget.chapters.length,
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                    AnimatedClipRect(
                      open: _height == 300 || _height == 80,
                      horizontalAnimation: false,
                      verticalAnimation: true,
                      reverseDuration: const Duration(milliseconds: 600),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.ease,
                      child: StateChange<bool>(
                        notifier: widget.isLoading,
                        builder: (context, value) => AnimatedContainer(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          color: Colors.black,
                          height: _height,
                          duration: const Duration(milliseconds: 1500),
                          width: double.infinity,
                          child: SingleChildScrollView(
                            physics: widget.book == null
                                ? const NeverScrollableScrollPhysics()
                                : const ClampingScrollPhysics(),
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: SelectTitle(
                                          data: widget.bookItem.name,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // Padding(
                                      // padding: const EdgeInsets.all(8.0),
                                      widget.favorites,
                                      // ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AccentSubtitleWithDots(
                                      [
                                        'Capítulos ${widget.book?.totalChapters ?? 0}',
                                        (widget.bookItem.tag ??
                                            widget.book?.type ??
                                            'Desconhecido'),
                                      ],
                                      baseColor: AppThemeData.surface,
                                      highlightColor: AppThemeData.surfaceTwo,
                                      margin: const EdgeInsets.only(top: 0),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.white54,
                                ),
                                (widget.book?.sinopse.isEmpty ?? false)
                                    ? const SizedBox.shrink()
                                    : const Padding(
                                        padding: EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Text(
                                          "Sinopse",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                InkWellApp(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    if (!value) {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      0.5.delay(
                                        () => AboutScreen.showBottomSheet(
                                            context, widget.book!),
                                      );
                                    } else {
                                      final ScaffoldMessengerState messenger =
                                          ScaffoldMessenger.of(context);
                                      messenger.clearSnackBars();
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Informações do ${widget.bookItem.tag ?? 'livro'} não carregadas',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: ShortSinopse(
                                    '${widget.book?.sinopse}',
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 4,
                                    ),
                                  ),
                                ),
                                (widget.book?.categories.isEmpty ?? false)
                                    ? const SizedBox.shrink()
                                    : const Padding(
                                        padding: EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        child: Text(
                                          'Gêneros',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                (widget.book == null)
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8),
                                        child: SizedBox(
                                          height: 32,
                                          child: ListView.builder(
                                            controller: ScrollController(),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: (widget.book!.categories)
                                                .length,
                                            itemBuilder: (ctx, index) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 4,
                                                ),
                                                child: Chip(
                                                  backgroundColor:
                                                      Colors.blue[600],
                                                  label: Text(
                                                    (widget.book!
                                                        .categories)[index],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                (widget.book == null)
                                    ? const SizedBox.shrink()
                                    : const Divider(
                                        color: Colors.white54,
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Container(
                        margin:
                            const EdgeInsets.only(right: 90, left: 90, top: 4),
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AnimatedClipRect extends StatefulWidget {
  @override
  createState() => _AnimatedClipRectState();

  final Widget child;
  final bool open;
  final bool horizontalAnimation;
  final bool verticalAnimation;
  final Alignment alignment;
  final Duration duration;
  final Duration? reverseDuration;
  final Curve curve;
  final Curve? reverseCurve;

  ///The behavior of the controller when [AccessibilityFeatures.disableAnimations] is true.
  final AnimationBehavior animationBehavior;

  const AnimatedClipRect({
    Key? key,
    required this.child,
    required this.open,
    this.horizontalAnimation = true,
    this.verticalAnimation = true,
    this.alignment = Alignment.center,
    this.duration = const Duration(milliseconds: 500),
    this.reverseDuration,
    this.curve = Curves.linear,
    this.reverseCurve,
    this.animationBehavior = AnimationBehavior.normal,
  }) : super(key: key);
}

class _AnimatedClipRectState extends State<AnimatedClipRect>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
        duration: widget.duration,
        reverseDuration: widget.reverseDuration ?? widget.duration,
        vsync: this,
        // value: widget.open ? 1.0 : 0.0,
        animationBehavior: widget.animationBehavior);
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
        reverseCurve: widget.reverseCurve ?? widget.curve,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.open
        ? _animationController.forward()
        : _animationController.reverse();

    return ClipRect(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, child) {
          return Align(
            alignment: widget.alignment,
            heightFactor: widget.verticalAnimation ? _animation.value : 1.0,
            widthFactor: widget.horizontalAnimation ? _animation.value : 1.0,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class Field extends StatelessWidget {
  final TextEditingController? controller;
  final double height;
  final double width;
  const Field({
    super.key,
    this.controller,
    this.height = 30,
    this.width = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        cursorHeight: 17,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.5,
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        scrollPadding: const EdgeInsets.all(20.0),
        decoration: InputDecoration(
          label: const Text('Number'),
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
          contentPadding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 8,
            top: 8,
          ),

          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: Get.theme.colorScheme.primary,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: Get.theme.colorScheme.error,
            ),
          ),

          focusColor: Get.theme.colorScheme.background.withOpacity(0.5),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: Get.theme.colorScheme.secondary,
            ),
          ),
          // borderRadius: BorderRadius.circular(8.0),
          // color: Color(0xffF0F1F5),
        ),
        toolbarOptions: const ToolbarOptions(
          copy: true,
          paste: true,
          cut: true,
          selectAll: true,
        ),
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
    );
  }
}
