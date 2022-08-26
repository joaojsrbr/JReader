import 'package:com_joaojsrbr_reader/app/core/constants/iconsax_icons.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/controlers/favorites_controller.dart';
import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TwoButton extends GetView<FavoritesController> {
  const TwoButton({super.key});

  @override
  Widget build(BuildContext context) {
    final value = InheritedWidgetValueNotifier.of<bool>(context).value;
    return value
        ? IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () async {
              controller.searchQuery.clear();
            },
            icon: const Icon(Icons.remove),
          )
        : IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () async {
              await 0.35.delay(
                () => FocusScope.of(context).requestFocus(FocusNode()),
              );
            },
            icon: const Icon(Iconsax.close_circle),
          );
  }
}
