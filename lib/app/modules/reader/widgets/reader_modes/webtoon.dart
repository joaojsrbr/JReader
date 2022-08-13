import 'package:cached_network_image/cached_network_image.dart';
import 'package:com_joaojsrbr_reader/app/modules/reader/controlers/reader_controller.dart';
import 'package:com_joaojsrbr_reader/app/modules/reader/widgets/emoticons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:get/get.dart';

class Webtoon extends StatefulWidget {
  final ReaderController controller;
  final BaseCacheManager? cacheManager;
  const Webtoon({
    super.key,
    required this.controller,
    this.cacheManager,
  });

  @override
  State<Webtoon> createState() => _WebtoonState();
}

class _WebtoonState extends State<Webtoon> {
  Widget _buildItem(String url) {
    return Focus(
      autofocus: true,
      child: GestureDetector(
        onTap: () {
          widget.controller.showbotton.value =
              !widget.controller.showbotton.value;
          widget.controller.showAppbar.value =
              !widget.controller.showAppbar.value;
        },
        child: CachedNetworkImage(
          cacheManager: widget.cacheManager,
          cacheKey: url,
          // memCacheHeight: 2000,
          memCacheWidth: 1080,
          imageUrl: url,
          fit: BoxFit.fitWidth,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              SizedBox(
            height: context.height,
            child: Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
              ),
            ),
          ),
          errorWidget: (context, url, error) => SizedBox(
            height: context.height,
            child: const Center(
              child: EmoticonsView(
                text: "Error",
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureZoomBox(
      maxScale: 5.0,
      doubleTapScale: 1.5,
      child: Stack(
        children: <Widget>[
          Scrollbar(
            controller: widget.controller.scrollController,
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                cacheExtent: 5000,
                itemCount: widget.controller.content.length,
                controller: widget.controller.scrollController,
                itemBuilder: (context, index) {
                  return _KeepAlive(
                    key: ObjectKey(widget.controller.content[index]),
                    child: _buildItem(widget.controller.content[index]),
                  );
                },

                // children: controller.content
                //     .map(
                //       (element) => _KeepAlive(
                //         key: ObjectKey(element),
                //         child: _buildItem(element),
                //       ),
                //     )
                //     .toList(),
              ),
              // ListView.builder(
              //   shrinkWrap: true,
              //   cacheExtent: (200 * controller.content.length).toDouble(),
              //   controller: controller.scrollController,
              //   itemBuilder: (context, index) {
              //     return _buildItem(
              //       controller.content[index],
              //     );
              //   },
              //   itemCount: controller.content.length,
              // ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: Obx(
                () => AnimatedContainer(
                  height: widget.controller.showbotton.value
                      ? kToolbarHeight * 1.05
                      : 0,
                  width: double.infinity,
                  duration: const Duration(milliseconds: 450),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.55),
                  ),
                  curve: Curves.linear,
                  // padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                            ),
                          ),
                          minimumSize: widget.controller.size(context),
                          maximumSize: widget.controller.size(context),
                          alignment: Alignment.center,
                          elevation: 0.0,
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                        ),
                        onPressed: () {
                          widget.controller.onPrevius();
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const VerticalDivider(
                        width: 2,
                        color: Colors.transparent,
                      ),
                      Obx(
                        () => Text(widget.controller.titleEnd.value),
                      ),
                      const VerticalDivider(
                        width: 2,
                        color: Colors.transparent,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                            ),
                          ),
                          minimumSize: widget.controller.size(context),
                          maximumSize: widget.controller.size(context),
                          primary: Colors.transparent,
                          elevation: 0.0,
                          shadowColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                        ),
                        onPressed: () {
                          widget.controller.onNext(button: true);
                        },
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: Obx(
              () => AnimatedContainer(
                height: widget.controller.showAppbar.value
                    ? kToolbarHeight * 1.05
                    : 0,
                width: double.infinity,
                duration: const Duration(milliseconds: 450),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .background
                      .withOpacity(0.55),
                ),
                curve: Curves.linear,
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: const BackButton(),
                      ),
                    ),
                    Flexible(
                      flex: 6,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 65,
                        child: Obx(
                          () => Text(widget.controller.title.value),
                        ),
                      ),
                    ),
                    // Row(
                    //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         primary: Colors.transparent,
                    //         shadowColor: Colors.transparent,
                    //         surfaceTintColor: Colors.transparent,
                    //       ),
                    //       onPressed: () {},
                    //       child: Icon(Icons.arrow_back),
                    //     ),
                    //     ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         primary: Colors.transparent,
                    //         shadowColor: Colors.transparent,
                    //         surfaceTintColor: Colors.transparent,
                    //       ),
                    //       onPressed: () {},
                    //       child: Icon(Icons.arrow_forward),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeepAlive extends StatefulWidget {
  final Widget child;
  const _KeepAlive({
    super.key,
    required this.child,
  });

  @override
  State<_KeepAlive> createState() => __KeepAliveState();
}

class __KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
