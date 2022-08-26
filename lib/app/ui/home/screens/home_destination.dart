import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/session.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/loading_more_sliver_list_book_element/loading_more_sliver_list_book_element.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/popup_menu_button_homepage/popup_menu_button_homepage.dart';
import 'package:com_joaojsrbr_reader/app/widgets/section_list_title/section_list_title.dart';

import '../controlers/home_controller.dart';

class HomeDestination extends GetView<HomeController> {
  const HomeDestination({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      child: CustomScrollView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
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
            expandedHeight: 100,
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
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 10,
                      child: InheritedWidgetValueNotifier(
                        notifier: controller.title,
                        child: SectionListTitle(
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
                      child: InheritedWidgetValueNotifier(
                        notifier: controller.scans,
                        child: PopupMenuButtonHomepage(
                          onSelected: controller.onSelected,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          // SliverPadding(
          //   padding: const EdgeInsets.only(left: 0, top: 0),
          //   sliver: SliverPersistentHeader(
          //     // floating: true,
          //     delegate: DelegatePageHeader(
          //       maxExtent: 50,
          //       minExtent: 50,
          //       builder: (shrinkOffset, overlapsContent) {
          //         return Row(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               flex: 10,
          //               child: InheritedSectionListTitle(
          //                 notifier: controller.title,
          //                 child: SectionListTitle(
          //                   key: ObjectKey(controller.title.value),
          //                   style:
          //                       Theme.of(context).textTheme.headline6!.copyWith(
          //                             fontSize: 14,
          //                             fontWeight: FontWeight.w700,
          //                           ),
          //                 ),
          //               ),
          //             ),
          //             Flexible(
          //               child: InheritedPopupMenuButton(
          //                 notifier: controller.scans,
          //                 child: PopupMenuButtonHomepage(
          //                   onSelected: controller.onSelected,
          //                 ),
          //               ),
          //             )
          //           ],
          //         );
          //       },
          //     ),
          //   ),
          // ),
          InheritedWidgetValueNotifier(
            notifier: controller.itemBookSource,
            child: const LoadingMoreSliverListBookElement(),
          ),
        ],
      ),
    );
  }
}
