// ignore_for_file: prefer_final_fields

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com_joaojsrbr_reader/app/core/constants/sort.dart';
import 'package:com_joaojsrbr_reader/app/modules/book/controlers/book_screen_controller.dart';
import 'package:com_joaojsrbr_reader/app/modules/reader/controlers/reader_controller.dart';
import 'package:com_joaojsrbr_reader/app/services/agregadores/manga_host_services.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:com_joaojsrbr_reader/app/core/constants/ports.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/models/download.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/book_info.dart';
import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:com_joaojsrbr_reader/app/store/favorites_store.dart';
import 'package:com_joaojsrbr_reader/app/store/historic_store.dart';
import 'package:com_joaojsrbr_reader/app/widgets/accent_subtitle.dart';
import 'package:com_joaojsrbr_reader/app/widgets/animated_fade_out_in.dart';
import 'package:com_joaojsrbr_reader/app/widgets/sinopse.dart';
import 'package:com_joaojsrbr_reader/app/widgets/to_info_button.dart';

class BookScreen extends GetView<BookScreenController> {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoricStore store = Provider.of<HistoricStore>(context);

    return GetBuilder<BookScreenController>(
      autoRemove: false,
      didChangeDependencies: (state) {
        Historic.getAll(context);
        final FavoritesStore store = Provider.of<FavoritesStore>(context);
        // state.controller?.bookItem =
        //     ModalRoute.of(context)!.settings.arguments as BookItem;
        state.controller?.setbookItem =
            ModalRoute.of(context)!.settings.arguments as BookItem;

        state.controller?.setfavorites = Favorites(
            book: state.controller!.bookItem, store: store, context: context);

        IsolateNameServer.registerPortWithName(
            state.controller!.port.sendPort, Ports.DOWNLOAD);
        state.controller?.port.listen(state.controller?.sendListening);
        state.controller?.getDownloadItem();

        bookInfo(
                state.controller!.bookItem.url, state.controller!.bookItem.name)
            .then(
          (value) {
            if (!state.mounted) return;
            state.controller?.setbook = value;
            state.controller?.setchapters = value?.chapters ?? [];
            state.controller?.setisLoading = false;
          },
        ).catchError(
          (e) {
            if (!state.mounted) return;
            final ScaffoldMessengerState messenger =
                ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  'Algo deu errado ao obter as informações do ${state.controller?.bookItem.tag ?? 'livro'}.',
                ),
              ),
            );
          },
        );
      },
      builder: (controller) => Scaffold(
        // backgroundColor: CustomColors.background,
        body: CustomScrollView(
          controller: controller.scrollController,
          // physics: const BouncingScrollPhysics(),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              title: Obx(
                () => controller.pinnedTitle.value
                    ? AnimatedFadeOutIn<String>(
                        data: controller.bookItem.name,
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
                IconButton(
                  onPressed: controller.onPressed,
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
                    controller.sort,
                    key: ObjectKey('#icon${controller.sort.value}'),
                  ),
                ),
                controller.favorites.button,
              ],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        cacheManager: controller.customCacheManager,
                        filterQuality: FilterQuality.high,
                        httpHeaders: (controller.bookItem.imageURL2 ??
                                        controller.bookItem.imageURL)
                                    .contains('img-host.filestatic3.xyz') ||
                                controller.bookItem.imageURL
                                    .contains('img-host.filestatic3.xyz')
                            ? MangaHostServices.headers
                            : null,
                        memCacheHeight: 1762,
                        memCacheWidth: 1080,
                        fit: BoxFit.cover,
                        imageUrl: controller.bookItem.imageURL2 ??
                            controller.bookItem.imageURL,
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
                                    text: controller.bookItem.name,
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
                          Obx(
                            () => AccentSubtitleWithDots(
                              [
                                'Capítulos ${controller.book?.totalChapters ?? 0}',
                                (controller.bookItem.tag ??
                                    controller.book?.type ??
                                    'Desconhecido'),
                              ],
                              margin: const EdgeInsets.only(top: 8),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              isLoading: controller.isLoading.value,
                            ),
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
                    Obx(
                      () => ShortSinopse(
                        '${controller.book?.sinopse}',
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      child: FittedBox(
                        child: Obx(
                          () => ToInfoButton(
                            text:
                                'DETALHES DO ${controller.bookItem.tag?.toUpperCase() ?? 'LIVRO'}',
                            isLoading: controller.isLoading.value,
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                RoutesName.ABOUT,
                                arguments: controller.book,
                              );
                            },
                          ),
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
                          controller.downloadAllButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Obx(
                      () {
                        // final Chapter chapter = (sort.value == Sort.DESC)
                        //     ? _chapters.reversed.toList()[index]
                        //     : _chapters[index];

                        final Chapter chapter =
                            (controller.sort.value == Sort.DESC)
                                ? controller.chapters[index]
                                : controller.chapters.reversed.toList()[index];

                        final Download? downloadChapter =
                            (controller.sort.value == Sort.DESC)
                                ? controller.download[chapter.id]
                                : controller.download[chapter.id];

                        return ListTile(
                          title: Text(chapter.name),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 32),
                          trailing: Observer(
                            builder: ((context) {
                              final book =
                                  store.historic[controller.bookItem.id];
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
                            await Get.toNamed(
                              RoutesName.READER,
                              arguments: ReaderArguments(
                                totalChapters: int.parse(
                                    controller.book?.totalChapters ?? '0'),
                                book: controller.bookItem,
                                chapters: (controller.sort.value == Sort.DESC)
                                    ? controller.chapters
                                    : controller.chapters.reversed.toList(),
                                index: index,
                                position: store.historic[controller.bookItem.id]
                                    ?[chapter.id],
                              ),
                            );
                            controller.getDownloadItem();
                            // await Navigator.of(context).pushNamed(
                            //   RoutesName.READER,
                            //   arguments: ReaderArguments(
                            //     book: _bookItem,
                            //     chapters: (sort.value == Sort.DESC)
                            //         ? _chapters
                            //         : _chapters.reversed.toList(),
                            //     index: index,
                            //     position: store.historic[_bookItem.id]?[chapter.id],
                            //   ),
                            // );
                          },
                          onLongPress: () async {
                            final downloaded =
                                downloadChapter?.finished == true;
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

                            if (action == 'down') {
                              controller.downloadOne(chapter);
                            }
                          },
                        );
                      },
                    );
                  },
                  childCount: controller.chapters.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
