import 'package:com_joaojsrbr_reader/app/core/constants/iconsax_icons.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/controlers/favorites_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:state_change/state_change.dart';

class TwoButton extends GetView<FavoritesController> {
  const TwoButton({
    super.key,
    required this.valueNotifier,
  });

  final ValueNotifier<bool> valueNotifier;

  @override
  Widget build(BuildContext context) {
    return StateChange<bool>(
      notifier: valueNotifier,
      builder: (context, value) => value
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
            ),
    );
  }
}
