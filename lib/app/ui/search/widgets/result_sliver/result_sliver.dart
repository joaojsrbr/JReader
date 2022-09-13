// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:com_joaojsrbr_reader/app/core/utils/grid.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/tag_info.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';
import 'package:com_joaojsrbr_reader/app/widgets/sliver_grid_builder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_change/state_change.dart';

class ResultSliver extends StatelessWidget {
  const ResultSliver({
    Key? key,
    required this.valueNotifier,
  }) : super(key: key);

  final ValueNotifier<List<BookItem>> valueNotifier;

  @override
  Widget build(BuildContext context) {
    return StateChange<List<BookItem>>(
      notifier: valueNotifier,
      builder: (context, lista) => lista.isEmpty
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
              sliver: SliverGridBuilder<BookItem>(
                gridDelegate: Grid.slivergrid,
                lista: lista,
                builder: (context, index, book) {
                  return BookElement(
                    onChange: (hashSet) {},
                    onLongPress: false,
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
              ),
              // sliver: SliverGrid(
              //   gridDelegate: Grid.slivergrid,
              //   delegate: SliverChildBuilderDelegate(
              //     (context, index) {
              //       final BookItem book = lista[index];
              //       return BookElement(
              //         onChange: (hashSet) {},
              //         onLongPress: false,
              //         tag: taginfo(book.imageURL),
              //         memCacheWidth: 330,
              //         memCacheHeight: 459,
              //         is18: book.is18,
              //         headers: book.headers,
              //         imageURL: book.imageURL,
              //         imageURL2: book.imageURL2,
              //         onTap: () {
              //           Get.toNamed(
              //             RoutesName.BOOK,
              //             arguments: book,
              //           );
              //         },
              //       );
              //     },
              //     childCount: lista.length,
              //   ),
              // ),
            ),
    );
  }
}
