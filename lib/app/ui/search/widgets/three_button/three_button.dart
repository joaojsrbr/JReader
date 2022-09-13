import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:com_joaojsrbr_reader/app/ui/search/controlers/search_controller.dart';
import 'package:state_change/state_change.dart';

class ThreeButton extends GetView<SearchController> {
  const ThreeButton({
    super.key,
    required this.listabool,
  });
  final List<ValueNotifier<bool>> listabool;

  @override
  Widget build(BuildContext context) {
    // print('$value1 - $value2');
    return StateListChange<bool>(
      notifier: listabool,
      builder: (context, value1, value2) => value1
          ? IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () async {
                controller.textEditingController.clear();
                controller.results.value = [];
              },
              icon: const Icon(Icons.remove),
            )
          : value2
              ? Container(
                  width: 15,
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : const SizedBox.shrink(),
    );
  }
}
