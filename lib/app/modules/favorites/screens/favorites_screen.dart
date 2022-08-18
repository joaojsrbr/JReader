import 'package:com_joaojsrbr_reader/app/core/utils/grid.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/modules/favorites/controlers/favorites_controller.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:com_joaojsrbr_reader/app/store/favorites_store.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoritesStore store = Provider.of<FavoritesStore>(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        title: const Text('Favoritos'),
        leading: const SizedBox.shrink(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Favorites.getAll(context);
        },
        child: Observer(
          builder: (context) {
            final List<BookItem> favorites = store.items;

            return GridView.builder(
              controller: controller.scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: favorites.length,
              scrollDirection: Axis.vertical,
              gridDelegate: Grid.slivergrid,
              itemBuilder: (context, index) {
                final BookItem book = favorites[index];

                return BookElement(
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
                    // Navigator.of(context).pushNamed(
                    //   RoutesName.BOOK,
                    //   arguments: book,
                    // );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
