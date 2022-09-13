import 'package:com_joaojsrbr_reader/app/core/utils/grid.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/controlers/favorites_controller.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/controlers/home_controller.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';
import 'package:com_joaojsrbr_reader/app/widgets/sliver_grid_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_change/state_change.dart';

class SliverGridBookElement extends GetView<FavoritesController> {
  const SliverGridBookElement({
    Key? key,
    required this.valueNotifier,
  }) : super(key: key);

  final ValueNotifier<List<BookItem>> valueNotifier;

  // final HashSet<String> hashSet = HashSet();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
      sliver: StateChange<List<BookItem>>(
        notifier: valueNotifier,
        builder: (context, value) => SliverGridBuilder<BookItem>(
          key: ObjectKey(value),
          gridDelegate: Grid.slivergrid,
          lista: value,
          builder: (context, index, book) {
            return BookElement(
              tag: book.tag,
              cacheManager: controller.baseCacheManager,
              onLongPress: true,
              key: ValueKey(book.name),
              memCacheWidth: 330,
              memCacheHeight: 459,
              is18: book.is18,
              headers: book.headers,
              imageURL: book.imageURL,
              hashSet: Get.find<HomeController>().hashset,
              onChange: (hashSet) {},
              imageURL2: book.imageURL2,
              onTap: () {
                Get.toNamed(
                  RoutesName.BOOK,
                  arguments: book,
                );
              },
            );
          },
        ),
        //  SliverGrid(
        //   key: ObjectKey(value),
        //   gridDelegate: Grid.slivergrid,
        //   delegate: SliverChildBuilderDelegate(
        //     childCount: value.length,
        //     (context, index) {
        //       final book = value[index];
        //       return BookElement(
        //         tag: book.tag,
        //         cacheManager: controller.baseCacheManager,
        //         onLongPress: true,
        //         key: ValueKey(book.name),
        //         memCacheWidth: 330,
        //         memCacheHeight: 459,
        //         is18: book.is18,
        //         headers: book.headers,
        //         imageURL: book.imageURL,
        //         hashSet: Get.find<HomeController>().hashset,
        //         onChange: (hashSet) {},
        //         imageURL2: book.imageURL2,
        //         onTap: () {
        //           Get.toNamed(
        //             RoutesName.BOOK,
        //             arguments: book,
        //           );
        //           // Navigator.push(
        //           //   context,
        //           //   CustomNamedPageTransition(
        //           //     MyApp.mtAppKey,
        //           //     RoutesName.BOOK,
        //           //     arguments: heroId,
        //           //   ),
        //           // );
        //         },
        //       );
        //     },
        //   ),
        // ),
      ),
    );
  }
}
