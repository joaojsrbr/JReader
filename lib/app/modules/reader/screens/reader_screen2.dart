import 'package:com_joaojsrbr_reader/app/modules/book/controlers/book_screen_controller.dart';
import 'package:com_joaojsrbr_reader/app/modules/reader/controlers/reader_controller.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:com_joaojsrbr_reader/app/store/historic_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
// import 'package:webtoon_reader/webtoon_reader.dart';
import 'package:com_joaojsrbr_reader/app/core/packages/webtoon_reader/lib/webtoon_reader.dart';

class ReaderScreen2 extends GetView<ReaderController> {
  const ReaderScreen2({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ReaderController>(
        autoRemove: false,
        didChangeDependencies: (state) async {
          final HistoricStore store = Provider.of<HistoricStore>(context);
          final args =
              ModalRoute.of(context)!.settings.arguments as ReaderArguments;

          controller.setbook = args.book;
          controller.setindex = args.index;
          controller.setchapters = args.chapters;
          controller.sethistoric = Historic(
              bookID: controller.book.id, context: context, store: store);
          controller.setinitPosition = args.position;
          controller.setsort = Get.find<BookScreenController>().sort.value;
          controller.settotalChapters = args.totalChapters;
        },
        builder: (controller) {
          // var width = MediaQuery.of(context).size.width;
          // var height = MediaQuery.of(context).size.height;
          return SafeArea(
            child: WebtoonReader(
              urls: controller.content,
            ),
          );
        },
        // OnlineMangaReaderWidget(
        //   key: ValueKey(controller.content),
        //   pages: controller.content
        //       .map(
        //         (element) => pm.Page(url: element, index: controller.index),
        //       )
        //       .toList(),
        //   topWidget: Container(),
        //   bottomWidget: Container(),
        //   readerTitle: '',
        //   onBottom: () {},
        //   onTop: () {},
        // ),
        // builder: (controller) => PhotoViewGallery(
        //   scrollDirection: Axis.vertical,

        //   // itemCount: controller.content.length,

        //   pageOptions: [
        //     PhotoViewGalleryPageOptions.customChild(
        //       child: ScrollablePositionedList.builder(
        //         itemScrollController: controller.itemScrollController,
        //         itemPositionsListener: controller.itemPositionsListener,
        //         // itemCount: index,
        //         shrinkWrap: true,
        //         itemCount: controller.content.length,
        //         itemBuilder: (context, index) => CachedNetworkImage(
        //           imageUrl: controller.content[index],
        //         ),
        //       ),

        //       minScale: PhotoViewComputedScale.contained * 1,
        //       maxScale: PhotoViewComputedScale.covered * 2.0,
        //       initialScale: PhotoViewComputedScale.contained * 1.0,
        //       //  heroAttributes: PhotoViewHeroAttributes(
        //       //      tag: widget.data.chapterImage[i].number)
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
