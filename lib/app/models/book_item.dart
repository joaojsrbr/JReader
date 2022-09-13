// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

Map<String, String> headers(String url) {
  String baseURL = url;

  return {
    'Origin': baseURL,
    'Referer': '$baseURL/',
    'accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'upgrade-insecure-requests': '1',
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36',
  };
}

class BookItem {
  final String id;

  final String url;
  final String? tag;
  final String name;
  final String imageURL;
  final String? imageURL2;
  final String? lastChapter;
  final Map<String, String>? headers;
  final bool? is18;

  BookItem({
    required this.id,
    required this.url,
    required this.name,
    required this.imageURL,
    this.lastChapter,
    this.imageURL2,
    this.headers,
    this.is18,
    this.tag,
    String? heroid,
  });

  Map<String, String?> get toMap {
    return {
      'id': id,
      'url': url,
      'tag': tag,
      'lastChapter': lastChapter,
      'name': name,
      'imageURL': imageURL,
      'imageURL2': imageURL2,
    };
  }

  @override
  bool operator ==(covariant BookItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.url == url &&
        other.tag == tag &&
        other.name == name &&
        other.imageURL == imageURL &&
        other.imageURL2 == imageURL2 &&
        other.lastChapter == lastChapter &&
        mapEquals(other.headers, headers) &&
        other.is18 == is18;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        url.hashCode ^
        tag.hashCode ^
        name.hashCode ^
        imageURL.hashCode ^
        imageURL2.hashCode ^
        lastChapter.hashCode ^
        headers.hashCode ^
        is18.hashCode;
  }
}
