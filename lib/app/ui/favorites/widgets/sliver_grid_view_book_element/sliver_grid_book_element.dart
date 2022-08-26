import 'package:com_joaojsrbr_reader/app/core/utils/grid.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';
import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliverGridBookElement extends StatelessWidget {
  const SliverGridBookElement({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = InheritedWidgetValueNotifier.of<List<BookItem>>(context).value
        as List<BookItem>;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverGrid.extent(
        maxCrossAxisExtent: Grid.slivergrid.maxCrossAxisExtent,
        mainAxisSpacing: Grid.slivergrid.mainAxisSpacing,
        childAspectRatio: Grid.slivergrid.childAspectRatio,
        crossAxisSpacing: Grid.slivergrid.crossAxisSpacing,
        children: value
            .map(
              (e) => BookElement(
                tag: e.tag,
                onLongPress: () {
                  if (kDebugMode) {
                    print('onLongPress');
                  }
                },
                memCacheWidth: 330,
                memCacheHeight: 459,
                is18: e.is18,
                headers: e.headers,
                imageURL: e.imageURL,
                imageURL2: e.imageURL2,
                onTap: () {
                  Get.toNamed(
                    RoutesName.BOOK,
                    arguments: e,
                  );
                },
              ),
            )
            .toList(),
      ),
      // delegate: SliverChildBuilderDelegate(
      //   (context, index) {
      //     final BookItem book = InheritedNotifierBookElement.of(context)[index];
      // return BookElement(
      //   tag: book.tag,
      //   memCacheWidth: 330,
      //   memCacheHeight: 459,
      //   is18: book.is18,
      //   headers: book.headers,
      //   imageURL: book.imageURL,
      //   imageURL2: book.imageURL2,
      //   onTap: () {
      //     Get.toNamed(
      //       RoutesName.BOOK,
      //       arguments: book,
      //     );
      //   },
      // );
      //   },
      //   childCount: InheritedNotifierBookElement.of(context).length,
      // ),
    );
  }
}
