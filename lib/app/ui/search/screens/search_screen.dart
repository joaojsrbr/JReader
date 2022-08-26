import 'package:com_joaojsrbr_reader/app/ui/search/controlers/search_controller.dart';
import 'package:com_joaojsrbr_reader/app/ui/search/widgets/result_sliver/result_sliver.dart';
import 'package:com_joaojsrbr_reader/app/ui/search/widgets/three_button/three_button.dart';
import 'package:com_joaojsrbr_reader/app/widgets/inherited_twowidget.dart';
import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            snap: false,
            pinned: false,
            floating: false,
            centerTitle: false,
            expandedHeight: 122,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: <Widget>[
                  const SizedBox(height: 90.0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 16.0),
                    child: SizedBox(
                      height: 38.0,
                      width: double.infinity,
                      child: TextField(
                        controller: controller.textEditingController,
                        onSubmitted: (value) => controller.onSubmitted(
                          value.trimLeft().trimRight(),
                          context,
                        ),
                        keyboardType: TextInputType.text,
                        cursorHeight: 22,
                        textAlign: TextAlign.start,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          label: const Text('Search'),
                          suffixIcon: InheritedTwoWidgetValueNotifier(
                            first: controller.isSearching,
                            second: controller.isLoading,
                            child: const ThreeButton(),
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
                          // filled: true,

                          focusColor:
                              Get.theme.colorScheme.background.withOpacity(0.5),
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
                        // onSubmitted: (value) {
                        //   FocusScope.of(context).requestFocus(
                        //     FocusNode(),
                        //   );
                        // },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InheritedWidgetValueNotifier(
            notifier: controller.results,
            child: ResultSliver(
              key: ObjectKey(controller.results),
            ),
          ),
        ],
      ),
    );
  }
}
