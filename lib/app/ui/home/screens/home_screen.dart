import 'package:com_joaojsrbr_reader/app/ui/favorites/controlers/favorites_controller.dart';
import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/screens/home_destination.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:loading_more_list/loading_more_list.dart';

import 'package:com_joaojsrbr_reader/app/ui/favorites/screens/favorites_destination.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/controlers/home_controller.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/navbar_scroll_to_hide_widget.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      body: GetBuilder<HomeController>(
        id: #home,
        autoRemove: false,
        didChangeDependencies: (state) {
          Favorites.getAll(context);
          Historic.getAll(context);
        },
        builder: (controller) => TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.tabController,
          children: const [
            HomeDestination(),
            FavoritesDestination(),
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
