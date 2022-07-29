// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:A.N.R/app/modules/favorites/screens/favorites_screen.dart';
import 'package:A.N.R/app/modules/home/controlers/home_controller.dart';
import 'package:A.N.R/app/modules/home/widget/indicator_builder/indicator_builder.dart';
import 'package:A.N.R/app/modules/home/widget/navbar_scroll_to_hide_widget.dart';
import 'package:A.N.R/app/services/historic.dart';
import 'package:A.N.R/app/services/session.dart';
import 'package:A.N.R/app/widgets/book_element.dart';
import 'package:A.N.R/app/widgets/section_list_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:A.N.R/app/models/book_item.dart';
import 'package:A.N.R/app/routes/routes.dart';

import 'package:loading_more_list/loading_more_list.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // List<Widget> _screen = const [
    //   HomeDestination(),
    //   FavoritesScreen(),
    // ];
    return Scaffold(
      key: _scaffoldKey,
      body: GetBuilder<HomeController>(
        id: #home,
        didChangeDependencies: (state) {
          // Favorites.getAll(context);
          Historic.getAll(context);
        },
        builder: (controller) => TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.tabController,
          children: const [
            HomeDestination(
              key: PageStorageKey("Home"),
            ),
            FavoritesScreen(
              key: PageStorageKey("Fav"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ScrollToHideWidgetState(
        scrollController: controller.scrollController,
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          child: Obx(
            () => NavigationBar(
              height: 60,
              selectedIndex: controller.destinationSelected.value,
              backgroundColor: Theme.of(context).colorScheme.background,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              onDestinationSelected: controller.onDestinationSelected,
              destinations: const [
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.home_rounded,
                  ),
                  label: "Home",
                  icon: Icon(
                    Icons.home_outlined,
                  ),
                ),
                NavigationDestination(
                  selectedIcon: Icon(
                    Icons.favorite,
                  ),
                  label: "Favorito",
                  icon: Icon(
                    Icons.favorite_outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeDestination extends GetView<HomeController> {
  const HomeDestination({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      child: LoadingMoreCustomScrollView(
        rebuildCustomScrollView: true,
        controller: controller.scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            stretch: true,
            title: const Text('A.N.R'),
            leading: const SizedBox(
              height: 0,
              width: 0,
            ),
            leadingWidth: 0,
            actions: [
              IconButton(
                onPressed: () async {
                  Session().signOut();
                  await Future.delayed(const Duration(milliseconds: 250));
                  Get.toNamed(RoutesName.LOGIN);
                },
                icon: const Icon(Icons.logout),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RoutesName.SEARCH);
                },
                icon: const Icon(Icons.search),
              ),
              // IconButton(
              //   onPressed: () {
              //     Navigator.of(context).pushNamed(RoutesName.FAVORITES);
              //   },
              //   icon: const Icon(Icons.favorite),
              // ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 0, top: 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 10,
                    child: Obx(
                      () => SectionListTitle(
                        controller.title.value,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                        key: ObjectKey(controller.title.value),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Obx(
                      () => PopupMenuButton<Scans>(
                        shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        color: Theme.of(context).colorScheme.background,
                        // enabled: !controller.itemBookRepository.isLoading,
                        icon: const Icon(Icons.filter_list),
                        initialValue: controller.scans.value,
                        onSelected: controller.onSelected,
                        padding: const EdgeInsets.only(right: 12),
                        itemBuilder: (ctx) => <PopupMenuEntry<Scans>>[
                          const PopupMenuItem(
                            value: Scans.NEOX,
                            child: Text('Neox'),
                          ),
                          const PopupMenuItem(
                            value: Scans.RANDOM,
                            child: Text('Random'),
                          ),
                          const PopupMenuItem(
                            value: Scans.MARK,
                            child: Text('Mark'),
                          ),
                          const PopupMenuItem(
                            value: Scans.CRONOS,
                            child: Text('Cronos'),
                          ),
                          const PopupMenuItem(
                            value: Scans.PRISMA,
                            child: Text('Prisma'),
                          ),
                          const PopupMenuItem(
                            value: Scans.REAPER,
                            child: Text('Reaper'),
                          ),
                          const PopupMenuItem(
                            value: Scans.MANGA_HOST,
                            child: Text('Manga Host'),
                          ),
                          const PopupMenuItem(
                            value: Scans.ARGOS,
                            child: Text('Argos'),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Obx(
            () => LoadingMoreSliverList(
              key: PageStorageKey(controller.index.value),
              SliverListConfig<BookItem>(
                gridDelegate: controller.gridDelegate,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                indicatorBuilder: (ctx, indicatorStatus) => indicatorBuilder(
                    ctx, indicatorStatus, controller.inrefresh.value),
                sourceList: controller.itemBookRepository,
                itemBuilder: (context, book, index) {
                  // print(item.name);
                  // print(controller.itemBookRepository.length);
                  return BookElement(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    tag: book.tag,
                    is18: book.is18,
                    headers: book.headers,
                    imageURL: book.imageURL,
                    imageURL2: book.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: book,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );

    // return Scaffold(
    //   key: _scaffoldKey,
    //   body: GetBuilder<HomeController>(
    //     id: #homepage,
    //     didChangeDependencies: (state) {
    //       Favorites.getAll(context);
    //       Historic.getAll(context);
    //     },
    //     builder: (controller) => NestedScrollView(
    //       controller: controller.scrollController,
    //       clipBehavior: Clip.hardEdge,
    //       floatHeaderSlivers: true,
    //       physics: const BouncingScrollPhysics(
    //           parent: AlwaysScrollableScrollPhysics()),
    //       // padding: const EdgeInsets.only(bottom: 16),
    //       headerSliverBuilder: (context, innerBoxIsScrolled) => [
    //         SliverAppBar(
    //           floating: true,
    //           snap: true,
    //           stretch: true,
    //           title: const Text('A.N.R'),
    //           leading: const SizedBox(
    //             height: 0,
    //             width: 0,
    //           ),
    //           leadingWidth: 0,
    //           actions: [
    //             IconButton(
    //               onPressed: () async {
    //                 Get.find<Session>().signOut();
    //                 await Future.delayed(const Duration(milliseconds: 250));
    //                 Get.toNamed(RoutesName.LOGIN);
    //               },
    //               icon: const Icon(Icons.logout),
    //             ),
    //             IconButton(
    //               onPressed: () {
    //                 Navigator.of(context).pushNamed(RoutesName.SEARCH);
    //               },
    //               icon: const Icon(Icons.search),
    //             ),
    //             IconButton(
    //               onPressed: () {
    //                 Navigator.of(context).pushNamed(RoutesName.FAVORITES);
    //               },
    //               icon: const Icon(Icons.favorite),
    //             )
    //           ],
    //         ),
    //       ],

    //       body: RefreshIndicator(
    //         onRefresh: controller.handleGetDatas,
    //         child: ListView(
    //           padding: const EdgeInsets.only(bottom: 20.0, top: 0),
    //           children: [
    //             // const SectionListTitle('Argos - Últimos adicionados'),
    //             const SectionListTitle('Argos - Popular'),
    //             Obx(
    // () => BookElementHorizontalList(
    //                 isLoading: controller.isLoading.value,
    //                 itemCount: controller.argos.length,
    //                 itemData: (index) {
    //                   final BookItem book = controller.argos[index];
    //                     return BookElementData(
    //                     tag: book.tag,
    //                     imageURL: book.imageURL,
    //                     imageURL2: book.imageURL2,
    //                     onTap: () {
    //                       Navigator.of(context).pushNamed(
    //                         RoutesName.BOOK,
    //                         arguments: book,
    //                       );
    //                     },
    //                   );
    //                 },
    //               ),
    //             ),
    //             const SectionListTitle('Neox - Últimos adicionados'),
    //             Obx(
    //               () => BookElementHorizontalList(
    //                 isLoading: controller.isLoading.value,
    //                 itemCount: controller.neox.length,
    //                 itemData: (index) {
    //                   final BookItem book = controller.neox[index];
    //                   return BookElementData(
    //                     tag: book.tag,
    //                     imageURL: book.imageURL,
    //                     imageURL2: book.imageURL2,
    //                     onTap: () {
    //                       Navigator.of(context).pushNamed(
    //                         RoutesName.BOOK,
    //                         arguments: book,
    //                       );
    //                     },
    //                   );
    //                 },
    //               ),
    //             ),
    //             const SectionListTitle('Random Scan - Últimos adicionados'),
    //             Obx(
    //               () => BookElementHorizontalList(
    //                 isLoading: controller.isLoading.value,
    //                 itemCount: controller.random.length,
    //                 itemData: (index) {
    //                   final BookItem book = controller.random[index];

    //                   return BookElementData(
    //                     tag: book.tag,
    //                     imageURL: book.imageURL2 ?? book.imageURL,
    //                     imageURL2: book.imageURL2,
    //                     onTap: () {
    //                       Navigator.of(context).pushNamed(
    //                         RoutesName.BOOK,
    //                         arguments: book,
    //                       );
    //                     },
    //                   );
    //                 },
    //               ),
    //             ),
    //             const SectionListTitle('Mark Scans - Últimos adicionados'),
    //             Obx(
    //               () => BookElementHorizontalList(
    //                 isLoading: controller.isLoading.value,
    //                 itemCount: controller.mark.length,
    //                 itemData: (index) {
    //                   final BookItem book = controller.mark[index];

    //                   return BookElementData(
    //                     tag: book.tag,
    //                     imageURL: book.imageURL,
    //                     imageURL2: book.imageURL2,
    //                     onTap: () {
    //                       Navigator.of(context).pushNamed(
    //                         RoutesName.BOOK,
    //                         arguments: book,
    //                       );
    //                     },
    //                   );
    //                 },
    //               ),
    //             ),
    //             const SectionListTitle('Cronos Scans - Últimos adicionados'),
    //             Obx(
    //               () => BookElementHorizontalList(
    //                 isLoading: controller.isLoading.value,
    //                 itemCount: controller.cronos.length,
    //                 itemData: (index) {
    //                   final BookItem book = controller.cronos[index];
    //                   return BookElementData(
    //                     tag: book.tag,
    //                     headers: book.headers,
    //                     imageURL: book.imageURL,
    //                     imageURL2: book.imageURL2,
    //                     onTap: () {
    //                       Navigator.of(context).pushNamed(
    //                         RoutesName.BOOK,
    //                         arguments: book,
    //                       );
    //                     },
    //                   );
    //                 },
    //               ),
    //             ),
    //             const SectionListTitle('Prisma Scans - Últimos adicionados'),
    //             Obx(
    //               () => BookElementHorizontalList(
    //                 isLoading: controller.isLoading.value,
    //                 itemCount: controller.prisma.length,
    //                 itemData: (index) {
    //                   final BookItem book = controller.prisma[index];
    //                   return BookElementData(
    //                     tag: book.tag,
    //                     headers: book.headers,
    //                     imageURL: book.imageURL,
    //                     imageURL2: book.imageURL2,
    //                     onTap: () {
    //                       Navigator.of(context).pushNamed(
    //                         RoutesName.BOOK,
    //                         arguments: book,
    //                       );
    //                     },
    //                   );
    //                 },
    //               ),
    //             ),
    //             const SectionListTitle('Reaper Scans - Últimos adicionados'),
    //             Obx(
    //               () => BookElementHorizontalList(
    //                 isLoading: controller.isLoading.value,
    //                 itemCount: controller.reaper.length,
    //                 itemData: (index) {
    //                   final BookItem book = controller.reaper[index];
    //                   return BookElementData(
    //                     tag: book.tag,
    //                     headers: book.headers,
    //                     imageURL: book.imageURL,
    //                     imageURL2: book.imageURL2,
    //                     onTap: () {
    //                       Navigator.of(context).pushNamed(
    //                         RoutesName.BOOK,
    //                         arguments: book,
    //                       );
    //                     },
    //                   );
    //                 },
    //               ),
    //             ),
    //             const SectionListTitle('Mangá Host - Últimos adicionados'),
    //             Obx(
    //               () => BookElementHorizontalList(
    //                 isLoading: controller.isLoading.value,
    //                 itemCount: controller.mangaHost.length,
    //                 itemData: (index) {
    //                   final BookItem book = controller.mangaHost[index];
    //                   return BookElementData(
    //                     tag: book.tag,
    //                     is18: book.is18,
    //                     headers: book.headers,
    //                     imageURL: book.imageURL,
    //                     imageURL2: book.imageURL2,
    //                     onTap: () {
    //                       Navigator.of(context).pushNamed(
    //                         RoutesName.BOOK,
    //                         arguments: book,
    //                       );
    //                     },
    //                   );
    //                 },
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
