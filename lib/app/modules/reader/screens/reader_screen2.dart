import 'package:com_joaojsrbr_reader/app/modules/book/controlers/book_screen_controller.dart';
import 'package:com_joaojsrbr_reader/app/modules/reader/controlers/reader_controller.dart';
import 'package:com_joaojsrbr_reader/app/modules/reader/widgets/reader_modes/webtoon.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:com_joaojsrbr_reader/app/store/historic_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

class ReaderScreen2 extends GetView<ReaderController> {
  const ReaderScreen2({super.key});

  static final CacheManager customCacheManager = CacheManager(
    Config(
      'Reader-Image',
      stalePeriod: const Duration(minutes: 10),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<ReaderController>(
          autoRemove: false,
          didChangeDependencies: (state) {
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

            controller.setcontext = context;
          },
          builder: (controller) {
            return Webtoon(
              cacheManager: customCacheManager,
              controller: controller,
            );
          },
        ),
      ),
    );
  }
}
