import 'package:com_joaojsrbr_reader/app/core/utils/grid.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/tag_info.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';
import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultSliver extends StatelessWidget {
  const ResultSliver({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lista = InheritedWidgetValueNotifier.of<List<BookItem>>(context).value
        as List<BookItem>;

    return lista.isEmpty
        ? SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              alignment: Alignment.center,
              child: Text(
                'Não foi encontrado nenhum resultado para a sua pesquisa.',
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
          )
        : SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            sliver: SliverGrid(
              gridDelegate: Grid.slivergrid,
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final BookItem book = lista[index];
                  return BookElement(
                    tag: taginfo(book.imageURL),
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
                childCount: lista.length,
              ),
            ),
          );
  }
}
