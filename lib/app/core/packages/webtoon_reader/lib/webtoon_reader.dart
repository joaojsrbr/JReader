library webtoon_reader;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sliver_tools/sliver_tools.dart';
import 'package:webtoon_reader/const.dart';
import 'package:webtoon_reader/controller/webtoon_controller.dart';

class WebtoonReader extends GetView<WebtoonController> {
  final RxList<String> urls;

  WebtoonReader({
    super.key,
    required this.urls,
  });

  Widget _buildItem(String url) {
    return SizedBox(
      child: GestureDetector(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, progressIndicator) =>
              SizedBox(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(
                value: progressIndicator.progress,
              ),
            ),
          ),
        ),
      ),
    );
  }

  final TransformationController transformationController =
      TransformationController();
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<WebtoonController>(
      () => WebtoonController(),
    );

    var imageScrollViewWidget = Obx(
      () {
        var content = <Widget>[];

        for (var i = 0; i < urls.length; i++) {
          content.add(_buildItem(urls[i]));
        }

        return InteractiveViewer(
          transformationController: transformationController,
          child: SizedBox(
            child: Stack(
              children: [
                CustomScrollView(
                  primary: true,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(content),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverStack(
            children: [
              SliverFillRemaining(
                child: imageScrollViewWidget,
              ),
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Obx(
                    () => AnimatedContainer(
                      height: controller.showAppbar.value
                          ? kToolbarHeight * 1.2
                          : 0,
                      duration: appBarAnimationDuration(),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: const BackButton(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
