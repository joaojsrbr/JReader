import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/widgets/sliver_flexible_space_bar.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/widgets/sliver_grid_view_book_element/sliver_grid_view_observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controlers/favorites_controller.dart';

class FavoritesDestination extends StatefulWidget {
  const FavoritesDestination({super.key});

  @override
  State<FavoritesDestination> createState() => FavoritesDestinationState();
}

class FavoritesDestinationState extends State<FavoritesDestination>
    with AutomaticKeepAliveClientMixin<FavoritesDestination> {
  final controller = Get.find<FavoritesController>();
  @override
  void didChangeDependencies() async {
    if (!mounted) return;
    await Favorites.getAll(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: controller.key,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return;
          await Favorites.updateAll(context);
          if (!mounted) return;
          await Favorites.getAll(context);
        },
        child: CustomScrollView(
          cacheExtent: double.maxFinite,
          // cacheExtent: 9999,
          controller: controller.scrollController,
          physics: const ClampingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: const [
            SliverAppBar(
              title: Text('Favoritos'),
              leading: SizedBox.shrink(),
              leadingWidth: 0,
              actions: [],
              expandedHeight: 125.0,
              snap: false,
              floating: false,
              flexibleSpace: SliverFlexibleSpaceBar(),
            ),
            SliverGridObserver(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
