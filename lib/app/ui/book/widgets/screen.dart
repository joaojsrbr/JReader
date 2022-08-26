import 'package:cached_network_image/cached_network_image.dart';
import 'package:com_joaojsrbr_reader/app/widgets/resize_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';

import 'package:com_joaojsrbr_reader/app/core/constants/sort.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/models/download.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/stores/historic_store.dart';
import 'package:com_joaojsrbr_reader/app/ui/book/widgets/select_title.dart';
import 'package:com_joaojsrbr_reader/app/ui/reader/controlers/reader_controller.dart';
import 'package:com_joaojsrbr_reader/app/widgets/accent_subtitle.dart';
import 'package:com_joaojsrbr_reader/app/widgets/animated_fade_out_in.dart';
import 'package:com_joaojsrbr_reader/app/widgets/delegate_page_header.dart';
import 'package:com_joaojsrbr_reader/app/widgets/sinopse.dart';
import 'package:com_joaojsrbr_reader/app/widgets/to_info_button.dart';

import '../controlers/book_screen_controller.dart';

class Screen extends GetView<BookScreenController> {
  const Screen({
    super.key,
    required this.store,
  });

  final HistoricStore store;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            // floating: true,
            pinned: true,
            delegate: DelegatePageHeader(
              maxExtent: (60 * MediaQuery.of(context).size.height) / 100,
              minExtent: kToolbarHeight * 1.4,
              builder: (shrinkOffset, overlapsContent) {
                final bool end = shrinkOffset.clamp(0, 500) > 410;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: ResizeI(
                        url: controller.bookItem.imageURL2 ??
                            controller.bookItem.imageURL,
                        headers: controller.bookItem.headers,
                        initialData: const Size(1080, 1762),
                        builder: (context, size) {
                          final Size sizes = size.data!;
                          return CachedNetworkImage(
                            cacheManager: controller.customCacheManager,
                            filterQuality: FilterQuality.high,
                            // height: 2000,
                            // maxHeightDiskCache: 200,
                            httpHeaders: controller.bookItem.headers,
                            memCacheHeight: 1762,
                            memCacheWidth: 1080,
                            // memCacheHeight: 1762,
                            // memCacheWidth: 1080,
                            height: sizes.height,
                            width: sizes.width,
                            fit: BoxFit.cover,
                            imageUrl: controller.bookItem.imageURL2 ??
                                controller.bookItem.imageURL,
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      top: 0,
                      bottom: -1,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0, 0.3, 0.5, 0.95],
                            colors: [
                              Theme.of(context).colorScheme.background,
                              !end
                                  ? Colors.transparent
                                  : Theme.of(context).colorScheme.background,
                              !end
                                  ? Colors.transparent
                                  : Theme.of(context).colorScheme.background,
                              Theme.of(context).colorScheme.background,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 35,
                      left: 3,
                      child: AnimatedOpacity(
                        opacity: (shrinkOffset.clamp(0, 500) > 350) ? 0 : 1,
                        duration: const Duration(milliseconds: 350),
                        child: const BackButton(),
                      ),
                    ),
                    Positioned(
                      top: 35,
                      right: 3,
                      height: 36,
                      child: AnimatedOpacity(
                        opacity: (shrinkOffset.clamp(0, 500) > 350) ? 0 : 1,
                        duration: const Duration(milliseconds: 350),
                        child: controller.favorites.button,
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedContainer(
                            alignment: Alignment.centerLeft,
                            duration: const Duration(milliseconds: 200),
                            height: shrinkOffset.clamp(0, 500) >
                                    ((60 * MediaQuery.of(context).size.height) /
                                            100) /
                                        2
                                ? 45
                                : (controller.bookItem.name.length > 60)
                                    ? 100
                                    : 45,
                            width: context.width,
                            padding: const EdgeInsets.only(left: 26, right: 26),
                            child: AnimatedDefaultTextStyle(
                              overflow: end
                                  ? TextOverflow.ellipsis
                                  : TextOverflow.clip,
                              maxLines: end ? 2 : 4,
                              style: TextStyle(
                                fontSize: end ? 16 : 19,
                                overflow: end ? TextOverflow.ellipsis : null,
                                fontWeight: FontWeight.w600,
                              ),
                              duration: const Duration(milliseconds: 350),
                              child: SelectTitle(
                                data: controller.bookItem.name,
                                end: end,
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            height: end ? 0 : 25.5,
                            child: ObxValue<RxBool>(
                              (isLoading) => AccentSubtitleWithDots(
                                [
                                  'Capítulos ${controller.book?.totalChapters ?? 0}',
                                  (controller.bookItem.tag ??
                                      controller.book?.type ??
                                      'Desconhecido'),
                                ],
                                margin: const EdgeInsets.only(top: 4),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                isLoading: isLoading.value,
                              ),
                              controller.isLoading,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ObxValue<RxBool>(
                    (isLoading) => ShortSinopse(
                      '${controller.book?.sinopse}',
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      isLoading: isLoading.value,
                    ),
                    controller.isLoading,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: FittedBox(
                      child: ObxValue<RxBool>(
                        (isLoading) => ToInfoButton(
                          text:
                              'DETALHES DO ${controller.bookItem.tag?.toUpperCase() ?? 'LIVRO'}',
                          isLoading: isLoading.value,
                          onPressed: () {
                            Get.toNamed(
                              RoutesName.ABOUT,
                              arguments: controller.book,
                            );
                          },
                        ),
                        controller.isLoading,
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: controller.onPressed,
                              padding: const EdgeInsets.only(right: 12),
                              icon: ObxValue<Rx<Sort>>(
                                (sort) => AnimatedFadeOutIn<Sort>(
                                  data: sort.value,
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
                            controller.downloadAllButton(),
                          ],
                        ),
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
                            final book = store.historic[controller.bookItem.id];
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
    );
  }
}

// class Tela1 extends GetView<BookScreenController> {
//   const Tela1({
//     super.key,
//     required this.store,
//   });

//   final HistoricStore store;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: CustomColors.background,
//       body: CustomScrollView(
//         // controller: controller.scrollController,
//         // physics: const BouncingScrollPhysics(),
//         physics: const AlwaysScrollableScrollPhysics(),
//         slivers: [
//           SliverAppBar(
//             title: ObxValue<RxBool>(
//               (pinnedTitle) => pinnedTitle.value
//                   ? AnimatedFadeOutIn<String>(
//                       data: controller.bookItem.name,
//                       initialData: '',
//                       duration: const Duration(milliseconds: 250),
//                       builder: (value) => Text(
//                         value,
//                         key: ValueKey(value),
//                       ),
//                     )
//                   : const SizedBox.shrink(),
//               controller.pinnedTitle,
//             ),
//             pinned: true,
//             elevation: 0,
//             centerTitle: false,
//             expandedHeight: (71 * MediaQuery.of(context).size.height) / 100,
//             actions: [
//               IconButton(
//                 onPressed: controller.onPressed,
//                 padding: const EdgeInsets.only(right: 12),
//                 icon: ObxValue<Rx<Sort>>(
//                   (sort) => AnimatedFadeOutIn<Sort>(
//                     data: sort.value,
//                     builder: (data) {
//                       late Widget widget;
//                       switch (data) {
//                         case Sort.DESC:
//                           widget = const Icon(
//                             Icons.arrow_drop_up_rounded,
//                             size: 50,
//                           );
//                           break;
//                         case Sort.ASC:
//                           widget = const Icon(
//                             Icons.arrow_drop_down_rounded,
//                             size: 50,
//                           );
//                           break;
//                       }
//                       return widget;
//                     },
//                   ),
//                   controller.sort,
//                   key: ObjectKey('#icon${controller.sort.value}'),
//                 ),
//               ),
//               controller.favorites.button,
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               collapseMode: CollapseMode.pin,
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Positioned.fill(
//                     child: CachedNetworkImage(
//                       cacheManager: controller.customCacheManager,
//                       filterQuality: FilterQuality.high,
//                       httpHeaders: controller.bookItem.headers,
//                       memCacheHeight: 1762,
//                       memCacheWidth: 1080,
//                       fit: BoxFit.cover,
//                       imageUrl: controller.bookItem.imageURL2 ??
//                           controller.bookItem.imageURL,
//                     ),
//                   ),
//                   Positioned.fill(
//                     top: 0,
//                     bottom: -1,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           stops: const [0, 0.5, 0.95],
//                           colors: [
//                             Theme.of(context).colorScheme.background,
//                             Colors.transparent,
//                             Theme.of(context).colorScheme.background,
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned.fill(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 24),
//                           child: SelectableText.rich(
//                             onSelectionChanged: (selection, cause) {
//                               if (cause.reactive.value ==
//                                   SelectionChangedCause.toolbar) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: const Text(
//                                       "Copiado para a área de transferência",
//                                     ),
//                                     backgroundColor: Theme.of(context)
//                                         .colorScheme
//                                         .background,
//                                   ),
//                                 );
//                               }
//                             },
//                             toolbarOptions: const ToolbarOptions(
//                               copy: true,
//                               selectAll: true,
//                             ),
//                             TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: controller.bookItem.name,
//                                   style: const TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // child: Text(
//                           //   _bookItem.name,
//                           //   style: const TextStyle(
//                           //     fontSize: 22,
//                           //     fontWeight: FontWeight.w600,
//                           //   ),
//                           // ),
//                         ),
//                         ObxValue<RxBool>(
//                           (isLoading) => AccentSubtitleWithDots(
//                             [
//                               'Capítulos ${controller.book?.totalChapters ?? 0}',
//                               (controller.bookItem.tag ??
//                                   controller.book?.type ??
//                                   'Desconhecido'),
//                             ],
//                             margin: const EdgeInsets.only(top: 8),
//                             padding: const EdgeInsets.symmetric(horizontal: 24),
//                             isLoading: isLoading.value,
//                           ),
//                           controller.isLoading,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 children: [
//                   ObxValue<RxBool>(
//                     (isLoading) => ShortSinopse(
//                       '${controller.book?.sinopse}',
//                       margin: const EdgeInsets.symmetric(vertical: 16),
//                       isLoading: isLoading.value,
//                     ),
//                     controller.isLoading,
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(bottom: 24),
//                     child: FittedBox(
//                       child: ObxValue<RxBool>(
//                         (isLoading) => ToInfoButton(
//                           text:
//                               'DETALHES DO ${controller.bookItem.tag?.toUpperCase() ?? 'LIVRO'}',
//                           isLoading: isLoading.value,
//                           onPressed: () {
//                             Get.toNamed(
//                               RoutesName.ABOUT,
//                               arguments: controller.book,
//                             );
//                           },
//                         ),
//                         controller.isLoading,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: double.infinity,
//                     margin: const EdgeInsets.only(bottom: 4),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Capítulos',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         controller.downloadAllButton(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Obx(
//             () => SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   return Obx(
//                     () {
//                       final Chapter chapter =
//                           (controller.sort.value == Sort.DESC)
//                               ? controller.chapters[index]
//                               : controller.chapters.reversed.toList()[index];

//                       final Download? downloadChapter =
//                           (controller.sort.value == Sort.DESC)
//                               ? controller.download[chapter.id]
//                               : controller.download[chapter.id];

//                       return ListTile(
//                         title: Text(chapter.name),
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 32),
//                         trailing: Observer(
//                           builder: ((context) {
//                             final book = store.historic[controller.bookItem.id];
//                             final bool read =
//                                 book?.containsKey(chapter.id) ?? false;

//                             final List<Widget> children = [];

//                             if (read) {
//                               children.add(
//                                 const Icon(Icons.visibility),
//                               );
//                             }
//                             if (downloadChapter?.finished == true) {
//                               children.add(
//                                 const SizedBox(width: 16),
//                               );
//                               children.add(
//                                 const Icon(Icons.download_done_rounded),
//                               );
//                             } else if (downloadChapter != null) {
//                               children.add(
//                                 const SizedBox(width: 16),
//                               );
//                               children.add(
//                                 const Icon(Icons.downloading_rounded),
//                               );
//                             }

//                             return Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: children,
//                             );
//                           }),
//                         ),
//                         onTap: () async {
//                           await Get.toNamed(
//                             RoutesName.READER,
//                             arguments: ReaderArguments(
//                               totalChapters: int.parse(
//                                   controller.book?.totalChapters ?? '0'),
//                               book: controller.bookItem,
//                               chapters: (controller.sort.value == Sort.DESC)
//                                   ? controller.chapters
//                                   : controller.chapters.reversed.toList(),
//                               index: index,
//                               position: store.historic[controller.bookItem.id]
//                                   ?[chapter.id],
//                             ),
//                           );
//                           controller.getDownloadItem();
//                         },
//                         onLongPress: () async {
//                           final downloaded = downloadChapter?.finished == true;
//                           final downloading = downloadChapter != null;

//                           if (downloaded || downloading) return;

//                           final String? action =
//                               await showModalBottomSheet<String>(
//                             context: context,
//                             builder: (context) {
//                               return Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   ListTile(
//                                     title: const Text('Baixar capítulo'),
//                                     leading: const Icon(Icons.download),
//                                     onTap: () =>
//                                         Navigator.of(context).pop('down'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );

//                           if (action == 'down') {
//                             controller.downloadOne(chapter);
//                           }
//                         },
//                       );
//                     },
//                   );
//                 },
//                 childCount: controller.chapters.length,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
