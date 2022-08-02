// ignore_for_file: prefer_final_fields

import 'dart:isolate';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:com_joaojsrbr_reader/app/core/constants/ports.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/start_download.dart';
import 'package:com_joaojsrbr_reader/app/databases/downloads_db.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/models/download.dart';
import 'package:com_joaojsrbr_reader/app/modules/reader/screens/reader_screen.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/book_info.dart';
import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:com_joaojsrbr_reader/app/store/favorites_store.dart';
import 'package:com_joaojsrbr_reader/app/store/historic_store.dart';
import 'package:com_joaojsrbr_reader/app/widgets/accent_subtitle.dart';
import 'package:com_joaojsrbr_reader/app/widgets/animated_fade_out_in.dart';
import 'package:com_joaojsrbr_reader/app/widgets/sinopse.dart';
import 'package:com_joaojsrbr_reader/app/widgets/to_info_button.dart';

// ignore: constant_identifier_names
enum Sort { DESC, ASC }

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final ReceivePort _port = ReceivePort();
  final ScrollController _scroll = ScrollController();

  late BookItem _bookItem;
  late Favorites _favorites;

  Book? _book;
  List<Chapter> _chapters = [];
  Map<String, Download> _download = {};

  bool _isLoading = true;
  RxBool _pinnedTitle = false.obs;

  void _scrollListener() {
    final double imageHeight = (70 * MediaQuery.of(context).size.height) / 100;

    if (!_pinnedTitle.value && _scroll.offset >= imageHeight) {
      _pinnedTitle.value = true;
    } else if (_pinnedTitle.value && _scroll.offset < imageHeight) {
      _pinnedTitle.value = false;
    }
  }

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

    setState(() {
      _download.update(item.chapterId, (_) => item, ifAbsent: () => item);
    });
    startDownload();
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

    return IconButton(
      icon: downloading
          ? const Icon(Icons.downloading_rounded)
          : const Icon(Icons.download_rounded),
      onPressed: _isLoading ? null : _downloadMany,
    );
  }

  @override
  void didChangeDependencies() {
    final FavoritesStore store = Provider.of<FavoritesStore>(context);

    _bookItem = ModalRoute.of(context)!.settings.arguments as BookItem;
    _favorites = Favorites(book: _bookItem, store: store, context: context);

    IsolateNameServer.registerPortWithName(_port.sendPort, Ports.DOWNLOAD);
    _port.listen(_sendListening);
    _getDownloadItem();

    bookInfo(_bookItem.url, _bookItem.name).then((value) {
      if (!mounted) return;
      setState(() {
        _book = value;
        _chapters = value?.chapters ?? [];
        _isLoading = false;
      });
    }).catchError((e) {
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
    });

    super.didChangeDependencies();
  }

  @override
  void initState() {
    sort = Sort.ASC.obs;
    _scroll.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_scrollListener)
      ..dispose();

    IsolateNameServer.removePortNameMapping(Ports.DOWNLOAD);

    super.dispose();
  }

  bool onpress = true;

  late Rx<Sort> sort;

  void onPressed() {
    // sort.value = value;
    onpress = !onpress;

    if (onpress) {
      sort.value = Sort.ASC;
    } else {
      sort.value = Sort.DESC;
    }
  }

  // Widget _buildSheet(BuildContext context) {
  //   return Container(
  //     height: 150,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Obx(
  //           () => PopupMenuButton<Sort>(
  //             shape: const ContinuousRectangleBorder(
  //               borderRadius: BorderRadius.all(
  //                 Radius.circular(20.0),
  //               ),
  //             ),
  //             color: Theme.of(context).colorScheme.background,
  //             // enabled: !controller.itemBookRepository.isLoading,

  //             icon: const Icon(Icons.sort),
  //             initialValue: sort.value,
  //             onSelected: onSelected,
  //             padding: const EdgeInsets.only(right: 12),
  //             itemBuilder: (context) => <PopupMenuEntry<Sort>>[
  //               const PopupMenuItem(
  //                 value: Sort.ASC,
  //                 child: Text('ASC'),
  //               ),
  //               const PopupMenuItem(
  //                 value: Sort.DESC,
  //                 child: Text('DESC'),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final HistoricStore store = Provider.of<HistoricStore>(context);
    final customCacheManager = CacheManager(
      Config(
        'Image-Manga-Anime',
        stalePeriod: const Duration(minutes: 10),
      ),
    );
    return Scaffold(
      // backgroundColor: CustomColors.background,
      body: CustomScrollView(
        controller: _scroll,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Obx(
              () => _pinnedTitle.value
                  ? AnimatedFadeOutIn<String>(
                      data: _bookItem.name,
                      initialData: '',
                      duration: const Duration(milliseconds: 250),
                      builder: (value) => Text(
                        value,
                        key: ValueKey(value),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            pinned: true,
            elevation: 0,
            centerTitle: false,
            expandedHeight: (71 * MediaQuery.of(context).size.height) / 100,
            actions: [
              // IconButton(
              //   onPressed: () => showModalBottomSheet(
              //     context: context,
              //     builder: (context) => _buildSheet(context),
              //   ),
              //   icon: const Icon(
              //     Icons.filter_list,
              //   ),
              // ),
              IconButton(
                onPressed: onPressed,
                padding: const EdgeInsets.only(right: 12),
                icon: ObxValue<Rx<Sort>>(
                  (sort) => AnimatedFadeOutIn<Sort>(
                    data: sort.value,
                    // data: (sort.value == Sort.ASC)
                    //     ? const Icon(Icons.arrow_drop_down_rounded)
                    //     : const Icon(Icons.arrow_drop_up_rounded),
                    builder: (data) {
                      late Widget widget;
                      switch (data) {
                        case Sort.DESC:
                          widget = const Icon(
                            Icons.arrow_drop_up_rounded,
                            size: 50,
                          );
                          break;
                        case Sort.ASC:
                          widget = const Icon(
                            Icons.arrow_drop_down_rounded,
                            size: 50,
                          );
                          break;
                      }
                      return widget;
                    },
                  ),
                  sort,
                  key: ObjectKey('#icon${sort.value}'),
                ),
              ),
              // Obx(
              //   () => PopupMenuButton<Sort>(
              //     shape: const ContinuousRectangleBorder(
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(20.0),
              //       ),
              //     ),
              //     color: Theme.of(context).colorScheme.background,
              //     // enabled: !controller.itemBookRepository.isLoading,

              //     // icon: const Icon(Icons.menu),
              //     icon: ObxValue<Rx<Sort>>(
              //       (sort) => AnimatedFadeOutIn<Sort>(
              //         data: sort.value,
              //         // data: (sort.value == Sort.ASC)
              //         //     ? const Icon(Icons.arrow_drop_down_rounded)
              //         //     : const Icon(Icons.arrow_drop_up_rounded),
              //         builder: (data) {
              //           late Widget widget;
              //           switch (data) {
              //             case Sort.DESC:
              //               widget = const Icon(
              //                 Icons.arrow_drop_up_rounded,
              //                 size: 50,
              //               );
              //               break;
              //             case Sort.ASC:
              //               widget = const Icon(
              //                 Icons.arrow_drop_down_rounded,
              //                 size: 50,
              //               );

              //               break;
              //           }
              //           return widget;
              //         },
              //       ),
              //       sort,
              //       key: ObjectKey('#icon${sort.value}'),
              //     ),
              //     key: ObjectKey('#PopupMenuButton${sort.value}'),
              //     initialValue: sort.value,
              //     onSelected: onSelected,
              //     padding: const EdgeInsets.only(right: 12),
              //     itemBuilder: (context) => <PopupMenuEntry<Sort>>[
              //       PopupMenuItem(
              //         value: Sort.ASC,
              //         child: Row(
              //           children: const [
              //             Icon(
              //               Icons.arrow_drop_down_rounded,
              //               size: 50,
              //             ),
              //             Text('ASC'),
              //           ],
              //         ),
              //       ),
              //       PopupMenuItem(
              //         value: Sort.DESC,
              //         child: Row(
              //           children: const [
              //             Icon(
              //               Icons.arrow_drop_up_rounded,
              //               size: 50,
              //             ),
              //             Text('DESC'),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              _favorites.button,
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      cacheManager: customCacheManager,
                      cacheKey: _bookItem.imageURL2 ?? _bookItem.imageURL,
                      filterQuality: FilterQuality.high,
                      memCacheHeight: 1762,
                      memCacheWidth: 1080,
                      fit: BoxFit.cover,
                      imageUrl: _bookItem.imageURL2 ?? _bookItem.imageURL,
                      // errorWidget: (context, url, erro) {
                      //   if (_bookItem.imageURL2 == null) {
                      //     return const SizedBox();
                      //   }

                      //   return CachedNetworkImage(
                      //     fit: BoxFit.cover,
                      //     imageUrl: _bookItem.imageURL2!,
                      //   );
                      // },
                    ),
                  ),
                  Positioned.fill(
                    top: 0,
                    bottom: -1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0, 0.5, 0.95],
                          colors: [
                            Theme.of(context).colorScheme.background,
                            Colors.transparent,
                            Theme.of(context).colorScheme.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: SelectableText.rich(
                            onSelectionChanged: (selection, cause) {
                              if (cause.reactive.value ==
                                  SelectionChangedCause.toolbar) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Copiado para a área de transferência"),
                                    backgroundColor: Colors.white,
                                  ),
                                );
                              }
                            },
                            toolbarOptions: const ToolbarOptions(
                              copy: true,
                              selectAll: true,
                            ),
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: _bookItem.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // child: Text(
                          //   _bookItem.name,
                          //   style: const TextStyle(
                          //     fontSize: 22,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                        ),
                        AccentSubtitleWithDots(
                          [
                            'Capítulos ${_book?.totalChapters ?? 0}',
                            (_bookItem.tag ?? _book?.type ?? 'Desconhecido'),
                          ],
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ShortSinopse(
                    '${_book?.sinopse}',
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    isLoading: _isLoading,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: FittedBox(
                      child: ToInfoButton(
                        text:
                            'DETALHES DO ${_bookItem.tag?.toUpperCase() ?? 'LIVRO'}',
                        isLoading: _isLoading,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            RoutesName.ABOUT,
                            arguments: _book,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Capítulos',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _downloadAllButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Obx(
                  () {
                    // final Chapter chapter = (sort.value == Sort.DESC)
                    //     ? _chapters.reversed.toList()[index]
                    //     : _chapters[index];

                    late Chapter chapter;

                    switch (sort.value) {
                      case Sort.DESC:
                        chapter = _chapters[index];
                        break;
                      case Sort.ASC:
                        chapter = _chapters.reversed.toList()[index];

                        break;
                    }

                    final Download? downloadChapter = _download[chapter.id];

                    return ListTile(
                      title: Text(chapter.name),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 32),
                      trailing: Observer(
                        builder: ((context) {
                          final book = store.historic[_bookItem.id];
                          final bool read =
                              book?.containsKey(chapter.id) ?? false;

                          final List<Widget> children = [];

                          if (read) {
                            children.add(
                              const Icon(Icons.visibility),
                            );
                          }
                          if (downloadChapter?.finished == true) {
                            children.add(
                              const SizedBox(width: 16),
                            );
                            children.add(
                              const Icon(Icons.download_done_rounded),
                            );
                          } else if (downloadChapter != null) {
                            children.add(
                              const SizedBox(width: 16),
                            );
                            children.add(
                              const Icon(Icons.downloading_rounded),
                            );
                          }

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: children,
                          );
                        }),
                      ),
                      onTap: () async {
                        await Navigator.of(context).pushNamed(
                          RoutesName.READER,
                          arguments: ReaderArguments(
                            book: _bookItem,
                            chapters: _chapters,
                            index: index,
                            position: store.historic[_bookItem.id]?[chapter.id],
                          ),
                        );

                        _getDownloadItem();
                      },
                      onLongPress: () async {
                        final downloaded = downloadChapter?.finished == true;
                        final downloading = downloadChapter != null;

                        if (downloaded || downloading) return;

                        final String? action =
                            await showModalBottomSheet<String>(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: const Text('Baixar capítulo'),
                                  leading: const Icon(Icons.download),
                                  onTap: () =>
                                      Navigator.of(context).pop('down'),
                                ),
                              ],
                            );
                          },
                        );

                        if (action == 'down') _downloadOne(chapter);
                      },
                    );
                  },
                );
              },
              childCount: _chapters.length,
            ),
          ),
        ],
      ),
    );
  }
}
