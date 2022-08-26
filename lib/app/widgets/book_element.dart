import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com_joaojsrbr_reader/app/core/constants/app_theme.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/controlers/home_controller.dart';
import 'package:com_joaojsrbr_reader/app/ui/reader/widgets/emoticons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class BookElement extends StatelessWidget {
  final bool? is18;
  final String? tag;
  final String imageURL;
  final String? imageURL2;
  final EdgeInsetsGeometry? margin;
  final Map<String, String>? headers;
  final void Function() onTap;
  final Function()? onLongPress;
  final int memCacheHeight;
  // final List<Chapter>? lastChapter;
  final int memCacheWidth;

  const BookElement({
    required this.imageURL,
    required this.onTap,
    // this.lastChapter,
    this.memCacheHeight = 770,
    this.memCacheWidth = 507,
    this.onLongPress,
    this.imageURL2,
    this.headers,
    this.margin,
    this.is18,
    this.tag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customCacheManager = Get.find<HomeController>().customCacheManager;
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: AppThemeData.surface,
          width: 112,
          height: 158.49,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  cacheKey: imageURL2 ?? imageURL,
                  cacheManager: customCacheManager,
                  fit: BoxFit.cover,
                  imageUrl: imageURL2 ?? imageURL,
                  httpHeaders: headers,
                  memCacheHeight: memCacheHeight,
                  memCacheWidth: memCacheWidth,
                  placeholder: (context, url) =>
                      Image.memory(kTransparentImage),
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
              Positioned(
                top: 6,
                left: 6,
                child: tag != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.5,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(22, 22, 30, 0.8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: FittedBox(
                          child: Text(
                            tag!,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: onTap, onLongPress: onLongPress),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookElementShimmer extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  const BookElementShimmer({this.margin, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: AppThemeData.surface,
        highlightColor: AppThemeData.surfaceTwo,
        child: Container(
          width: 112,
          height: 158.49,
          decoration: BoxDecoration(
            color: AppThemeData.surface,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

final Uint8List kTransparentImage = Uint8List.fromList(<int>[
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);
