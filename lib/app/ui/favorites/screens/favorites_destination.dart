import 'package:com_joaojsrbr_reader/app/ui/favorites/widgets/sliver_flexible_space_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/widgets/sliver_grid_view_book_element/sliver_grid_view_observer.dart';

import '../controlers/favorites_controller.dart';

class FavoritesDestination extends StatefulWidget {
  const FavoritesDestination({super.key});

  @override
  State<FavoritesDestination> createState() => _FavoritesDestinationState();
}

class _FavoritesDestinationState extends State<FavoritesDestination> {
  final controller = Get.find<FavoritesController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.key,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          if (!mounted) return;
          await Favorites.getAll(context);
        },
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          controller: controller.scrollController,
          slivers: const [
            SliverAppBar(
              title: Text('Favoritos'),
              leading: SizedBox.shrink(),
              leadingWidth: 0,
              expandedHeight: 125.0,
              snap: false,
              floating: false,
              flexibleSpace: SliverFlexibleSpaceBar(),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              sliver: SliverGridObserver(),
            ),
          ],
        ),
      ),
    );
  }
}
