import 'package:A.N.R/app/models/book.dart';
import 'package:A.N.R/app/models/book_item.dart';
import 'package:A.N.R/app/models/chapter.dart';
import 'package:A.N.R/app/core/utils/to_id.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class NeoxServices {
  static String get baseURL => 'https://neoxscans.net';

  static final DioCacheManager _cacheManager = DioCacheManager(
    CacheConfig(baseUrl: baseURL),
  );

  static Options _cacheOptions({String? subKey, bool? forceRefresh}) {
    return buildCacheOptions(
      const Duration(days: 15),
      subKey: subKey,
      forceRefresh: forceRefresh ?? true,
    );
    // options: Options(headers: headers));
  }

  static Map<String, String> get headers {
    return {
      'Origin': 'https://neoxscans.net/',
      'Referer': 'https://neoxscans.net/',
      'accept':
          'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
      'upgrade-insecure-requests': '1',
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.134 Safari/537.36',
    };
  }

  static Future<List<BookItem>> get lastAdded async {
    try {
      final List<BookItem> items = [];

      final Dio dio = Dio();
      final Options options = _cacheOptions();
      dio.interceptors.add(_cacheManager.interceptor);

      final Response response = await dio.get(baseURL, options: options);

      final Document document = parse(response.data);

      final List<Element> elements =
          document.querySelectorAll('#loop-content .row div.page-item-detail');

      for (Element element in elements) {
        final Element? a = element.querySelector('h3 a');
        final Element? img = element.querySelector('img');
        if (a == null || img == null) continue;

        final String url = (a.attributes['href'] ?? '').trim();
        final String name = a.text.trim();
        final String imageURL = (img.attributes['data-src'] ?? '').trim();
        final String? tag = element.querySelector('span')?.text.trim();

        final String? srcset = img.attributes['data-srcset'];
        final String? imageURL2 = srcset == null
            ? null
            : '$srcset,'
                .replaceAll(RegExp(r'([1-9])\w+,'), '')
                .trim()
                .split(' ')
                .where((value) => value.length > 3)
                .last
                .trim();

        if (url.isNotEmpty && name.isNotEmpty && imageURL.isNotEmpty) {
          items.add(
            BookItem(
              id: toId(name),
              url: url,
              tag: tag,
              name: name,
              imageURL: imageURL,
              imageURL2: imageURL2,
            ),
          );
        }
      }

      return items;
    } catch (e) {
      return [];
    }
  }

  static Future<List<BookItem>> search(String value) async {
    final List<BookItem> items = [];

    final String subKey = '?s=$value&post_type=wp-manga';
    final String url = '$baseURL/$subKey';

    final Dio dio = Dio();
    final Options options = _cacheOptions(subKey: subKey);
    dio.interceptors.add(_cacheManager.interceptor);

    final Response response = await dio.get(url, options: options);
    final Document document = parse(response.data);

    final List<Element> elements =
        document.querySelectorAll('.c-tabs-item div.row');

    for (Element element in elements) {
      final Element? a = element.querySelector('h3 a');
      final Element? img = element.querySelector('img');
      if (a == null || img == null) continue;

      final String url = (a.attributes['href'] ?? '').trim();
      final String name = a.text.trim();
      final String imageURL = (img.attributes['data-src'] ?? '').trim();

      final String? srcset = img.attributes['data-srcset'];
      final String? imageURL2 = srcset == null
          ? null
          : '$srcset,'
              .replaceAll(RegExp(r'([1-9])\w+,'), '')
              .trim()
              .split(' ')
              .where((value) => value.length > 3)
              .last
              .trim();

      if (url.isNotEmpty && name.isNotEmpty && imageURL.isNotEmpty) {
        items.add(BookItem(
          id: toId(name),
          url: url,
          name: name,
          imageURL: imageURL,
          imageURL2: imageURL2,
        ));
      }
    }

    return items;
  }

  static Future<Book> bookInfo(String url, String name) async {
    final Dio dio = Dio();
    Options options = _cacheOptions(subKey: url);
    dio.interceptors.add(_cacheManager.interceptor);

    Response response = await dio.get(url, options: options);
    Document document = parse(response.data);

    final List<Chapter> chapters = [];
    final List<String> categories = [];

    // Categories
    List<Element> elements = document.querySelectorAll('.genres-content a');
    for (var element in elements) {
      final String name = element.text.trim();
      if (name.isNotEmpty) categories.add(name);
    }

    // Type
    String? type;
    elements = document.querySelectorAll('.post-content_item');
    elements.removeWhere((element) {
      return element.querySelector('h5')?.text.trim().toLowerCase() != 'tipo';
    });

    if (elements.isNotEmpty) {
      type = elements[0].querySelector('.summary-content')?.text.trim();
    }

    // Sinopse
    final String sinopse =
        document.querySelector('.manga-excerpt')?.text.trim() ?? '';

    // Chapters
    elements = document.querySelectorAll('.main li > a');
    for (Element element in elements) {
      final url = (element.attributes['href'] ?? '').trim();
      final name = element.text.trim();

      if (url.isNotEmpty && name.isNotEmpty) {
        final String id = name
            .toLowerCase()
            .replaceAll('cap.', '')
            .replaceAll(RegExp(r'[^0-9.]'), '')
            .replaceAll('.', '_');

        chapters.add(Chapter(id: id, url: url, name: name));
      }
    }

    return Book(
      name: name,
      type: type,
      sinopse: sinopse,
      chapters: chapters,
      categories: categories,
    );
  }

  static Future<List<String>> getContent(String url) async {
    final List<String> content = [];

    final Dio dio = Dio();
    final Options options = _cacheOptions(subKey: url);
    dio.interceptors.add(_cacheManager.interceptor);

    final Response response = await dio.get(url, options: options);
    final Document document = parse(response.data);

    final List<Element> elements =
        document.querySelectorAll('.reading-content img');

    final List<Element> elementstext =
        document.querySelectorAll('.reading-content p');

    if (elementstext.isNotEmpty) {
      // elements.forEach((element) {print(element.text); });
    } else {
      for (Element element in elements) {
        final String url = (element.attributes['data-src'] ?? '').trim();
        if (url.isNotEmpty) content.add(url);
      }
    }

    return content;
  }
}
