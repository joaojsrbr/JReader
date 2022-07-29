import 'package:A.N.R/app/widgets/book_element.dart';
import 'package:flutter/material.dart';

class BookElementHorizontalList extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  final double height;
  final bool isLoading;

  final int itemCount;
  final BookElementData Function(int) itemData;

  final int loadingItemCount;

  final int memCacheHeigh;
  final int memCacheWidth;

  const BookElementHorizontalList({
    required this.itemCount,
    required this.itemData,
    this.loadingItemCount = 4,
    this.isLoading = false,
    this.height = 158.49,
    this.margin,
    this.memCacheWidth = 507,
    this.memCacheHeigh = 770,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 8),
      height: height,
      child: isLoading
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: loadingItemCount,
              itemBuilder: (_, index) => const BookElementShimmer(
                margin: EdgeInsets.symmetric(horizontal: 4),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (_, index) {
                final BookElementData data = itemData(index);
                return BookElement(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  tag: data.tag,
                  is18: data.is18,
                  memCacheHeight: memCacheHeigh,
                  memCacheWidth: memCacheWidth,
                  headers: data.headers,
                  imageURL: data.imageURL,
                  imageURL2: data.imageURL2,
                  onLongPress: data.onLongPress,
                  onTap: data.onTap,
                );
              },
            ),
    );
  }
}

class BookElementData {
  final bool? is18;
  final String? tag;
  final String imageURL;
  final String? imageURL2;
  final Function() onTap;
  final Function()? onLongPress;
  final Map<String, String>? headers;

  const BookElementData({
    required this.imageURL,
    required this.onTap,
    this.onLongPress,
    this.imageURL2,
    this.headers,
    this.is18,
    this.tag,
  });
}
