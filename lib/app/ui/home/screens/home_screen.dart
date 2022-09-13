import 'dart:collection';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:com_joaojsrbr_reader/app/core/constants/iconsax_icons.dart';
import 'package:com_joaojsrbr_reader/app/global_variable.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:com_joaojsrbr_reader/app/services/historic.dart';
import 'package:com_joaojsrbr_reader/app/ui/book/screens/book_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/controlers/favorites_controller.dart';
// import 'package:loading_more_list/loading_more_list.dart';

import 'package:com_joaojsrbr_reader/app/ui/favorites/screens/favorites_destination.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/controlers/home_controller.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/screens/home_destination.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/navigation_bar_home_page/navigation_bar_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidable/hidable.dart';
import 'package:state_change/state_change.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() async {
    await Favorites.getAll(context);
    if (!mounted) return;
    await Historic.getAll(context);

    super.didChangeDependencies();
  }

  @override
  void initState() {
    setupNotificaitons();
    super.initState();
  }

  void setupNotificaitons() async {
    AwesomeNotifications().actionStream.listen(
      (ReceivedNotification receivedNotification) async {
        final String? channelKey = receivedNotification.channelKey;
        if (channelKey == null) return;
        if (channelKey.contains('manga_notifications')) {
          final BookItem bookItem = BookItem(
            id: receivedNotification.payload!['id']!,
            url: receivedNotification.payload!['url']!,
            imageURL: receivedNotification.payload!['imageURL']!,
            name: receivedNotification.payload!['name']!,
            tag: receivedNotification.payload!['tag'],
            lastChapter: receivedNotification.payload!['lastChapter'],
            headers: headers(receivedNotification.payload!['url']!),
          );
          await GlobalVariable.navState.currentState!.push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 650),
              reverseTransitionDuration: const Duration(milliseconds: 650),
              settings: RouteSettings(arguments: bookItem),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const BookScreen(),
            ),
          );

          // await Navigator.of(context).pushNamed(
          //   RoutesName.BOOK,
          //   arguments: BookItem(
          //     id: receivedNotification.payload!['id']!,
          //     url: receivedNotification.payload!['url']!,
          //     imageURL: receivedNotification.payload!['imageURL']!,
          //     name: receivedNotification.payload!['name']!,
          //     tag: receivedNotification.payload!['tag'],
          //     lastChapter: receivedNotification.payload!['lastChapter'],
          //     headers: headers(receivedNotification.payload!['url']!),
          //   ),
          // );
        }
      },
    );
  }

  final controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StateChange<HashSet<String>>(
        notifier: controller.hashset,
        builder: (context, hashset) => ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: AnimatedCrossFade(
            firstCurve: Curves.easeInCubic,
            crossFadeState: hashset.isEmpty
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            secondCurve: Curves.easeInCubic,
            duration: const Duration(milliseconds: 450),
            firstChild: FloatingActionButton.extended(
              heroTag: null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Get.theme.colorScheme.background,
              label: Text('Itens: ${hashset.length}'),
              icon: const Icon(Iconsax.trash),
              onPressed: () async {
                await controller.hashset.removedb();
                if (!mounted) return;
                await Favorites.getAll(context);
              },
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ),
      ),
      // extendBody: true,
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.tabController,
        children: const [
          HomeDestination(),
          FavoritesDestination(),
        ],
      ),
      bottomNavigationBar: Hidable(
        controllers: [
          controller.scrollController,
          Get.find<FavoritesController>().scrollController
        ],
        preferredWidgetSize: const Size(double.infinity, 70),
        child: NavigationBarHomePage(
          onDestinationSelected: controller.onDestinationSelected,
          selectedIndex: controller.destinationSelected,
        ),
      ),
    );
  }
}
