import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'package:com_joaojsrbr_reader/app/core/utils/grid.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/loading_more_sliver_list_book_element/indicator_builder/indicator_builder.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';

class LoadingMoreSliverListBookElement extends StatelessWidget {
  const LoadingMoreSliverListBookElement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sourceList =
        InheritedWidgetValueNotifier.of<LoadingMoreBase<BookItem>>(context)
            .value as LoadingMoreBase<BookItem>;
    return LoadingMoreSliverList<BookItem>(
      SliverListConfig<BookItem>(
        gridDelegate: Grid.sliverlist,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        indicatorBuilder: indicatorBuilder,
        sourceList: sourceList,
        itemBuilder: (context, book, index) {
          return BookElement(
            key: ObjectKey(book.name),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            tag: book.tag,
            is18: book.is18,
            headers: book.headers,
            imageURL: book.imageURL,
            imageURL2: book.imageURL2,
            onTap: () => Get.toNamed(
              RoutesName.BOOK,
              arguments: book,
            ),
          );
        },
      ),
      key: ObjectKey(
        sourceList,
      ),
    );
  }
}
