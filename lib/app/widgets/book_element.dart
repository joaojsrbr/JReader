import 'dart:collection';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/controlers/hashset_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:state_change/state_change.dart';

import 'emoticons.dart';

class BookElement extends StatefulWidget {
  final bool? is18;
  final String? tag;
  final String imageURL;
  final String? imageURL2;
  final String? title;
  final EdgeInsetsGeometry? margin;
  final Map<String, String>? headers;
  final void Function() onTap;
  final bool onLongPress;
  final int memCacheHeight;
  final int memCacheWidth;
  final Curve curve;
  final Duration duration;
  final BaseCacheManager? cacheManager;
  final void Function(HashSet<String> hashSet) onChange;
  final HashSetController? hashSet;
  const BookElement({
    super.key,
    this.is18,
    this.tag,
    this.imageURL2,
    this.title,
    this.margin,
    this.headers,
    this.cacheManager,
    this.duration = const Duration(milliseconds: 650),
    this.curve = Curves.easeInOutCubic,
    this.hashSet,
    required this.onChange,
    required this.imageURL,
    required this.onTap,
    required this.onLongPress,
    required this.memCacheHeight,
    required this.memCacheWidth,
  });

  @override
  State<BookElement> createState() => _BookElementState();
}

class _BookElementState extends State<BookElement> {
  final ValueNotifier<HashSet<String>> nullhashSet =
      ValueNotifier(HashSet<String>());

  void onLongPress(String path) {
    if (widget.hashSet == null) return;
    if (widget.onLongPress && widget.hashSet != null) {
      widget.hashSet!.add(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StateChange<HashSet<String>>(
      notifier: widget.hashSet ?? nullhashSet,
      builder: (context, value) => AnimatedContainer(
        margin: widget.margin,
        duration: widget.duration,
        padding: EdgeInsets.all(
            value.contains(widget.imageURL2 ?? widget.imageURL) ? 10 : 0),
        curve: widget.curve,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 112,
            height: 158.49,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Material(
                    type: MaterialType.transparency,
                    child: CachedNetworkImage(
                      cacheKey: widget.imageURL2 ?? widget.imageURL,
                      cacheManager: widget.cacheManager,
                      fit: BoxFit.cover,
                      imageUrl: widget.imageURL2 ?? widget.imageURL,
                      httpHeaders: widget.headers,
                      memCacheHeight: widget.memCacheHeight,
                      memCacheWidth: widget.memCacheWidth,
                      placeholder: (context, url) =>
                          Image.memory(kTransparentImage),
                      errorWidget: (context, url, error) => SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: EmoticonsView(
                            text: "Error",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: widget.tag != null
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
                              widget.tag!,
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
                    child: InkWell(
                      onTap: () {
                        if (widget.hashSet != null) {
                          if (widget.hashSet!.value.isNotEmpty) {
                            onLongPress(widget.imageURL2 ?? widget.imageURL);
                            widget.onChange(value);
                          } else {
                            widget.onTap();
                          }
                        } else {
                          widget.onTap();
                        }
                      },
                      onLongPress: () {
                        if (widget.hashSet != null) {
                          if (widget.onLongPress &&
                              widget.hashSet!.value.isEmpty) {
                            onLongPress(widget.imageURL2 ?? widget.imageURL);
                            widget.onChange(value);
                          }
                        } else {}
                      },
                    ),
                  ),
                ),
              ],
            ),
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
