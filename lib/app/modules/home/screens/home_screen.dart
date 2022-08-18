import 'package:com_joaojsrbr_reader/app/core/constants/providers.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/grid.dart';
import 'package:com_joaojsrbr_reader/app/modules/favorites/controlers/favorites_controller.dart';
import 'package:com_joaojsrbr_reader/app/modules/home/widget/pop_menu_b.dart';
import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:loading_more_list/loading_more_list.dart';

import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/modules/favorites/screens/favorites_screen.dart';
import 'package:com_joaojsrbr_reader/app/modules/home/controlers/home_controller.dart';
import 'package:com_joaojsrbr_reader/app/modules/home/widget/delegate_page_header.dart';
import 'package:com_joaojsrbr_reader/app/modules/home/widget/indicator_builder/indicator_builder.dart';
import 'package:com_joaojsrbr_reader/app/modules/home/widget/navbar_scroll_to_hide_widget.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:com_joaojsrbr_reader/app/services/session.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';
import 'package:com_joaojsrbr_reader/app/widgets/section_list_title.dart';
import 'package:loading_more_list/loading_more_list.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  void _oninit(BuildContext context) {
    Favorites.getAll(context);
    Historic.getAll(context);
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> _screen = const [
    //   HomeDestination(),
    //   FavoritesScreen(),
    // ];
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      body: GetBuilder<HomeController>(
        id: #home,
        autoRemove: false,
        didChangeDependencies: (state) {
          _oninit(context);
          controller.itens.value = controller.itemBookRepository.value;
        },
        builder: (controller) => TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.tabController,
          children: const [
            HomeDestination(),
            FavoritesScreen(),
          ],
        ),
      ),
      bottomNavigationBar: ScrollToHideWidgetState(
        listcrollControllers: [
          controller.scrollController,
          Get.find<FavoritesController>().scrollController
        ],
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
                    Icons.favorite_rounded,
                  ),
                  label: "Favorito",
                  icon: Icon(
                    Icons.favorite_border_rounded,
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
        // rebuildCustomScrollView: true,
        controller: controller.scrollController,
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            stretch: true,
            title: const Text('HomePage'),
            leading: const SizedBox(
              height: 0,
              width: 0,
            ),
            leadingWidth: 0,
            actions: [
              IconButton(
                onPressed: () async {
                  await Session.signOut();
                  await Future.delayed(const Duration(milliseconds: 250));

                  Get.toNamed(RoutesName.LOGIN);
                },
                icon: const Icon(Icons.logout_rounded),
              ),
              IconButton(
                onPressed: () {
                  Get.toNamed(RoutesName.SEARCH);
                },
                icon: const Icon(Icons.search_rounded),
              ),
            ],
          ),
          // const SliverToBoxAdapter(
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //       top: 4.0,
          //       bottom: 4.0,
          //       left: 15,
          //       right: 15,
          //     ),
          //     child: Carousel(),
          //   ),
          // ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 0, top: 0),
            sliver: SliverPersistentHeader(
              // floating: true,
              delegate: DelegatePageHeader(
                maxExtent: 50,
                minExtent: 50,
                builder: (shrinkOffset, overlapsContent) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Obx(
                          () => SectionListTitle(
                            controller.title.value,
                            key: ObjectKey(controller.title.value),
                            style:
                                Theme.of(context).textTheme.headline6!.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: PopMenuB(
                          controller: controller,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          Obx(
            () => LoadingMoreSliverList(
              SliverListConfig<BookItem>(
                gridDelegate: Grid.sliverlist,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                indicatorBuilder: (ctx, indicatorStatus) => indicatorBuilder(
                    ctx, indicatorStatus, controller.inrefresh.value),
                sourceList: controller.itemBookRepository.value,
                itemBuilder: (context, book, index) {
                  return BookElement(
                    key: ObjectKey(book.name),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    tag: book.tag,
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
              key: controller.pageStorageKey(
                ObjectKey(controller.itemBookRepository.string),
                controller.scans.value.string,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class Carousel extends StatelessWidget {
//   const Carousel({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // if (kDebugMode) {
//     //   print(controller.itemBookRepository.value);
//     // }
//     return GetBuilder<HomeController>(
//       assignId: true,
//       autoRemove: false,
//       initState: (state) {
//         if (state.controller != null) {
//           state.controller!.itens.value =
//               state.controller!.itemBookRepository.value;
//         }
//       },
//       didChangeDependencies: (state) {
//         state.controller!.itens.value =
//             state.controller!.itemBookRepository.value;
//       },
//       id: 'Carousel',
//       builder: (controller) => Obx(
//         () => CarouselSlider.builder(
//           itemCount: controller.itens.length,
//           itemBuilder: (context, index, realIndex) {
//             if (controller.itens.isEmpty) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             return GestureDetector(
//               onTap: () {
//                 Get.toNamed(
//                   RoutesName.BOOK,
//                   arguments: controller.itens[index],
//                 );
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 5),
//                 width: context.width / .8,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: CachedNetworkImage(
//                     cacheKey: controller.itens[index].imageURL2 ??
//                         controller.itens[index].imageURL,
//                     cacheManager: controller.customCacheManager,
//                     fit: BoxFit.cover,
//                     imageUrl: controller.itens[index].imageURL2 ??
//                         controller.itens[index].imageURL,
//                     httpHeaders: controller.itens[index].headers,
//                     memCacheHeight: 498,
//                     memCacheWidth: 997,
//                     errorWidget: (context, url, error) => SizedBox(
//                       height: context.height,
//                       child: const Center(
//                         child: EmoticonsView(
//                           text: "Error",
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//           options: CarouselOptions(
//             aspectRatio: 1.3,
//             enlargeCenterPage: false,
//             autoPlayInterval: const Duration(seconds: 10),
//             autoPlayAnimationDuration: const Duration(milliseconds: 800),
//             autoPlayCurve: Curves.fastOutSlowIn,
//             viewportFraction: 1,
//             autoPlay: true,
//           ),
//         ),
//       ),
//     );
//   }
// }
