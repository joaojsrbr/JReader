import 'package:html/dom.dart';

class GetImage {
  static String bySrc(Element img) {
    return (img.attributes['data-src'] ?? img.attributes['src'] ?? '').trim();
  }

  static String? bySrcSet(Element img) {
    final String? src =
        img.attributes['data-srcset'] ?? img.attributes['srcset'];

    if (src == null) return null;

    return '$src,'
        .replaceAll(RegExp(r'([1-9])\w+,'), '')
        .trim()
        .split(' ')
        .where((value) => value.length > 3)
        .last
        .trim();
  }
}
