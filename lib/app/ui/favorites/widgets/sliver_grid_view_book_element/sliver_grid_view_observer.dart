import 'package:com_joaojsrbr_reader/app/ui/favorites/widgets/sliver_grid_view_book_element/sliver_grid_book_element.dart';
import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:com_joaojsrbr_reader/app/stores/favorites_store.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/controlers/favorites_controller.dart';

class SliverGridObserver extends GetView<FavoritesController> {
  const SliverGridObserver({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesStore store = Provider.of<FavoritesStore>(context);

    return Observer(
      builder: (context) {
        controller.items = store.items;
        controller.buildSearchList();
        return InheritedWidgetValueNotifier(
          notifier: controller.searchList,
          child: const SliverGridBookElement(),
        );
      },
    );
  }
}
