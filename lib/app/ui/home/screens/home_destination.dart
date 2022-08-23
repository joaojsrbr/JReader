import 'package:com_joaojsrbr_reader/app/core/constants/providers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'package:com_joaojsrbr_reader/app/core/utils/grid.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/session.dart';
import 'package:com_joaojsrbr_reader/app/widgets/delegate_page_header.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/indicator_builder/indicator_builder.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/pop_menu_b.dart';
import 'package:com_joaojsrbr_reader/app/widgets/book_element.dart';
import 'package:com_joaojsrbr_reader/app/widgets/section_list_title.dart';

import '../controlers/home_controller.dart';

class HomeDestination extends GetView<HomeController> {
  const HomeDestination({super.key});

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

          controller.obx(
            (state) => LoadingMoreSliverList<BookItem>(
              SliverListConfig<BookItem>(
                gridDelegate: Grid.sliverlist,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                indicatorBuilder: indicatorBuilder,
                sourceList: state!,
                itemBuilder: (context, book, index) {
                  return BookElement(
                    key: ObjectKey(book.name),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    tag: book.tag,
                    is18: book.is18,
                    headers: book.headers,
                    imageURL: book.imageURL,
                    imageURL2: book.imageURL2,
                    onTap: () => Get.toNamed(RoutesName.BOOK, arguments: book),
                  );
                },
              ),
              key: controller.pageStorageKey(
                ObjectKey(state),
                controller.scans.value.string,
              ),
            ),
          ),
          // Obx(
          //   () => LoadingMoreSliverList(
          //     SliverListConfig<BookItem>(
          //       gridDelegate: Grid.sliverlist,
          //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          //       indicatorBuilder: (ctx, indicatorStatus) => indicatorBuilder(
          //           ctx, indicatorStatus, controller.inrefresh.value),
          //       sourceList: controller.itemBookRepository.value,
          //       itemBuilder: (context, book, index) {
          //         return BookElement(
          //           key: ObjectKey(book.name),
          //           margin: const EdgeInsets.symmetric(horizontal: 4),
          //           tag: book.tag,
          //           is18: book.is18,
          //           headers: book.headers,
          //           imageURL: book.imageURL,
          //           imageURL2: book.imageURL2,
          //           onTap: () {
          //             Get.toNamed(
          //               RoutesName.BOOK,
          //               arguments: book,
          //             );
          //           },
          //         );
          //       },
          //     ),
          //     key: controller.pageStorageKey(
          //       ObjectKey(controller.itemBookRepository.string),
          //       controller.scans.value.string,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
