import 'package:com_joaojsrbr_reader/app/widgets/inherited_twowidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:com_joaojsrbr_reader/app/ui/search/controlers/search_controller.dart';

class ThreeButton extends GetView<SearchController> {
  const ThreeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final value1 = InheritedTwoWidgetValueNotifier.of<bool>(context).value1;
    final value2 = InheritedTwoWidgetValueNotifier.of<bool>(context).value2;
    // print('$value1 - $value2');
    return value1
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
            : const SizedBox.shrink();
  }
}
