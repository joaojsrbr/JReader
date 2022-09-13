import 'package:com_joaojsrbr_reader/app/ui/favorites/controlers/favorites_controller.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/widgets/two_button/two_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliverFlexibleSpaceBar extends GetView<FavoritesController> {
  const SliverFlexibleSpaceBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Column(
        children: <Widget>[
          const SizedBox(height: 90.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 16.0),
            child: SizedBox(
              height: 38.0,
              width: double.infinity,
              child: TextField(
                controller: controller.searchQuery,
                keyboardType: TextInputType.text,
                cursorHeight: 22,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  label: const Text('Search'),
                  suffixIcon: TwoButton(
                    valueNotifier: controller.isSearching,
                  ),
                  contentPadding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    borderSide: BorderSide(
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    borderSide: BorderSide(
                      color: Get.theme.colorScheme.error,
                    ),
                  ),

                  focusColor: Get.theme.colorScheme.background.withOpacity(0.5),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    borderSide: BorderSide(
                      color: Get.theme.colorScheme.secondary,
                    ),
                  ),
                  // borderRadius: BorderRadius.circular(8.0),
                  // color: Color(0xffF0F1F5),
                ),
                toolbarOptions: const ToolbarOptions(
                  copy: true,
                  paste: true,
                  cut: true,
                  selectAll: true,
                ),
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
