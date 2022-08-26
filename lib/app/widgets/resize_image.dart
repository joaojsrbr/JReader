import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResizeI extends StatelessWidget {
  const ResizeI({
    super.key,
    required this.url,
    required this.builder,
    this.headers,
    this.initialData,
  });

  // importante
  final Map<String, String>? headers;
  final String url;
  final Widget Function(BuildContext context, AsyncSnapshot<Size> size) builder;
  final Size? initialData;

  Future<Size> _calculateImageDimension(String url) {
    Completer<Size> completer = Completer();
    Image image = Image(
      image: CachedNetworkImageProvider(
        url,
        headers: headers,
      ),
    );
    image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo image, bool synchronousCall) {
              var myImage = image.image;
              Size size = Size(
                myImage.width.toDouble(),
                myImage.height.toDouble(),
              );
              completer.complete(size);
            },
            onChunk: (event) {
              // if (kDebugMode) {
              //   print(event.cumulativeBytesLoaded);
              // }
            },
            onError: (exception, stackTrace) {
              if (kDebugMode) {
                print(stackTrace);
              }
            },
          ),
        );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Size>(
      future: _calculateImageDimension(url),
      builder: builder,
      initialData: initialData,
    );
  }
}
