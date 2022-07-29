import 'package:A.N.R/app/core/utils/grid.dart';
import 'package:A.N.R/app/models/book_item.dart';
import 'package:A.N.R/app/modules/search/controlers/search_controller.dart';
import 'package:A.N.R/app/routes/routes.dart';
import 'package:A.N.R/app/services/tag_info.dart';
import 'package:A.N.R/app/widgets/book_element.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({Key? key}) : super(key: key);

  // bool _isLoading = false;
  // List<BookItem> _results = [];
  // Providers _provider = Providers.NEOX;

  // Future<void> _onSubmitted(String value) async {
  //   setState(() => _isLoading = true);

  //   List<BookItem> results = [];

  //   try {
  //     results = [];
  //     results = await search(value, _provider);
  //   } catch (e) {
  //     final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

  //     messenger.clearSnackBars();
  //     messenger.showSnackBar(
  //       const SnackBar(content: Text('Ocorreu um erro ao buscar pelo livro')),
  //     );
  //   } finally {
  //     setState(() {
  //       _results = results;
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          Obx(
            () => SliverAppBar(
              snap: false,
              // title: Text('${_provider.value} - Buscar livro...'),
              pinned: true,
              actions: const [
                // PopupMenuButton<Providers>(
                //   shape: const ContinuousRectangleBorder(
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(20.0),
                //     ),
                //   ),
                //   color: Theme.of(context).colorScheme.background,
                //   enabled: !controller.isLoading.value,
                //   initialValue: controller.provider.value,
                //   // onSelected: (value) => setState(() => _provider = value),
                //   itemBuilder: (ctx) => <PopupMenuEntry<Providers>>[
                //     const PopupMenuItem(
                //       value: Providers.NEOX,
                //       child: Text('Neox'),
                //     ),
                //     const PopupMenuItem(
                //       value: Providers.RANDOM,
                //       child: Text('Random'),
                //     ),
                //     const PopupMenuItem(
                //       value: Providers.MARK,
                //       child: Text('Mark'),
                //     ),
                //     const PopupMenuItem(
                //       value: Providers.CRONOS,
                //       child: Text('Cronos'),
                //     ),
                //     const PopupMenuItem(
                //       value: Providers.PRISMA,
                //       child: Text('Prisma'),
                //     ),
                //     const PopupMenuItem(
                //       value: Providers.REAPER,
                //       child: Text('Reaper'),
                //     ),
                //     const PopupMenuItem(
                //       value: Providers.MANGA_HOST,
                //       child: Text('Manga Host'),
                //     ),
                //     const PopupMenuItem(
                //       value: Providers.ARGOS,
                //       child: Text('Argos'),
                //     ),
                //   ],
                // )
              ],
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
          // SliverList(
          //   delegate: SliverChildListDelegate(
          //     [
          //       Results(
          //         scans: Scans.NEOX,
          //         title: 'Neox Scans',
          //       ),
          //       Results(
          //         scans: Scans.MARK,
          //         title: 'Mark Scans',
          //       ),
          //       Results(
          //         scans: Scans.RANDOM,
          //         title: 'RANDOM Scans',
          //       ),
          //       Results(
          //         scans: Scans.ARGOS,
          //         title: 'ARGOS Scans',
          //       ),
          //       Results(
          //         scans: Scans.REAPER,
          //         title: 'REAPER Scans',
          //       ),
          //       Results(
          //         scans: Scans.CRONOS,
          //         title: 'CRONOS Scans',
          //       ),
          //       Results(
          //         scans: Scans.MANGA_HOST,
          //         title: 'CRONOS Scans',
          //       ),
          //     ],
          //   ),
          // ),
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
                      gridDelegate: Grid.sliverDelegate,
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

// class Results extends GetView<SearchController> {
//   Results({
//     super.key,
//     required this.scans,
//     required this.title,
//   });
//   final Scans scans;
//   RxList<BookItem> lista = <BookItem>[].obs;

//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     switch (scans) {
//       case Scans.NEOX:
//         lista = controller.neox;
//         break;
//       case Scans.RANDOM:
//         lista = controller.random;
//         break;
//       case Scans.MARK:
//         lista = controller.mark;
//         break;
//       case Scans.CRONOS:
//         lista = controller.cronos;
//         break;
//       case Scans.PRISMA:
//         lista = controller.prisma;
//         break;
//       case Scans.REAPER:
//         lista = controller.reaper;
//         break;
//       case Scans.MANGA_HOST:
//         lista = controller.mangaHost;
//         break;
//       case Scans.ARGOS:
//         lista = controller.argos;
//         break;
//     }

//     return Obx(
//       () => Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: SectionListTitle(
//               title,
//               style: Theme.of(context).textTheme.headline6!.copyWith(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                   ),
//               key: ObjectKey(title),
//             ),
//           ),
//           BookElementHorizontalList(
//             itemCount: lista.length,
//             memCacheHeigh: 435,
//             memCacheWidth: 308,
//             itemData: (index) {
//               final BookItem book = lista[index];
//               return BookElementData(
//                 tag: book.tag,
//                 headers: book.headers,
//                 imageURL: book.imageURL,
//                 imageURL2: book.imageURL2,
//                 onTap: () {
//                   Navigator.of(context).pushNamed(
//                     RoutesName.BOOK,
//                     arguments: book,
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
