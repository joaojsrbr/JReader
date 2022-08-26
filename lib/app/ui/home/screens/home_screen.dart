import 'package:com_joaojsrbr_reader/app/ui/favorites/controlers/favorites_controller.dart';
import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/screens/home_destination.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/navigation_bar_home_page/navigation_bar_home_page.dart';
import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:loading_more_list/loading_more_list.dart';

import 'package:com_joaojsrbr_reader/app/ui/favorites/screens/favorites_destination.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/controlers/home_controller.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/navbar_to_hide/navbar_scroll_to_hide_widget.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void didChangeDependencies() async {
    await Favorites.getAll(context);
    if (!mounted) return;
    await Historic.getAll(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      // extendBody: true,
      key: scaffoldKey,
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.tabController,
        children: const [
          HomeDestination(),
          FavoritesDestination(),
        ],
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
          child: InheritedWidgetValueNotifier(
            notifier: controller.destinationSelected,
            child: NavigationBarHomePage(
              onDestinationSelected: controller.onDestinationSelected,
            ),
          ),
        ),
      ),
    );
  }
}
