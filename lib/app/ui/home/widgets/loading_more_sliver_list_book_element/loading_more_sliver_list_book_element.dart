import 'package:com_joaojsrbr_reader/app/core/utils/grid.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/ui/book/screens/book_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/loading_more_sliver_list_book_element/indicator_builder/indicator_builder.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:state_change/state_change.dart';

class LoadingMoreSliverListBookElement extends StatelessWidget {
  const LoadingMoreSliverListBookElement({
    super.key,
    required this.sourceList,
  });
  final ValueNotifier<LoadingMoreBase<BookItem>> sourceList;

  @override
  Widget build(BuildContext context) {
    return StateChange<LoadingMoreBase<BookItem>>(
      notifier: sourceList,
      builder: (context, sourceList) => LoadingMoreSliverList<BookItem>(
        SliverListConfig<BookItem>(
          gridDelegate: Grid.slivergrid,
          padding: const EdgeInsets.only(bottom: 30, left: 8, right: 8),
          indicatorBuilder: indicatorBuilder,
          sourceList: sourceList,
          itemBuilder: (context, data, index) {
            final book = data;
            return BookElement(
              key: ValueKey(book.name),
              onChange: (hashSet) {},
              onLongPress: false,
              cacheManager: BookScreen.customCacheManager,
              tag: book.tag,
              memCacheWidth: 330,
              memCacheHeight: 459,
              is18: book.is18,
              headers: book.headers,
              imageURL: book.imageURL,
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
        key: ObjectKey(
          sourceList,
        ),
      ),
    );
  }
}
