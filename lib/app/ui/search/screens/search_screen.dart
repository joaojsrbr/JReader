import 'package:com_joaojsrbr_reader/app/core/utils/grid.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/ui/search/controlers/search_controller.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/tag_info.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          Obx(
            () => SliverAppBar(
              snap: false,
              pinned: true,
              floating: true,
              centerTitle: false,
              bottom: AppBar(
                automaticallyImplyLeading: false,
                title: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: Center(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Digite o nome do livro',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: controller.isLoading.value
                            ? Container(
                                width: 20,
                                alignment: Alignment.centerRight,
                                child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : null,
                      ),
                      enabled: !controller.isLoading.value,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      keyboardAppearance: Brightness.dark,
                      onSubmitted: (value) => controller.onSubmitted(
                          value.trimLeft().trimRight(), context),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => controller.results.isEmpty
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
                          final BookItem book = controller.results[index];
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
                        childCount: controller.results.length,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
