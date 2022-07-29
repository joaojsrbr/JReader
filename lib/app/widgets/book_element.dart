import 'package:A.N.R/app/core/themes/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';

class BookElement extends StatelessWidget {
  final bool? is18;
  final String? tag;
  final String imageURL;
  final String? imageURL2;
  final EdgeInsetsGeometry? margin;
  final Map<String, String>? headers;
  final Function() onTap;
  final Function()? onLongPress;
  final int memCacheHeight;
  final int memCacheWidth;

  const BookElement({
    required this.imageURL,
    required this.onTap,
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
    final customCacheManager = CacheManager(
      Config(
        'Image-Manga-Anime',
        stalePeriod: const Duration(minutes: 30),
      ),
    );
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: CustomColors.surface,
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
                  // errorWidget: imageURL2 != null
                  //     ? (context, url, error) {
                  //         return CachedNetworkImage(
                  //           fit: BoxFit.cover,
                  //           imageUrl: imageURL2!,
                  //           httpHeaders: headers,
                  //         );
                  //       }
                  //     : null,
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
                    : const SizedBox(),
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

  const BookElementShimmer({this.margin, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: CustomColors.surface,
        highlightColor: CustomColors.surfaceTwo,
        child: Container(
          width: 112,
          height: 158.49,
          decoration: BoxDecoration(
            color: CustomColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
