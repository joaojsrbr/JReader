import 'package:com_joaojsrbr_reader/app/core/constants/strings.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/to_id.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class ReaperServices {
  static String get baseURL => Strings.reaperURL;

  static final DioCacheManager _cacheManager = DioCacheManager(
    CacheConfig(baseUrl: baseURL),
  );

  static Options _cacheOptions({String? subKey, bool? forceRefresh}) {
    return buildCacheOptions(
      const Duration(days: 15),
      subKey: subKey,
      forceRefresh: forceRefresh ?? true,
    );
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
          document.querySelectorAll('div.col-6.col-sm-6.col-md-6.col-xl-3');

      for (Element element in elements) {
        final Element? a = element.querySelector('a');
        final Element? h5 = element.querySelector('h5');
        final Element? img = element.querySelector('img');
        final Element? lastChapter = element.querySelector('.series-badge');

        if (a == null || h5 == null || img == null || lastChapter == null) {
          continue;
        }

        final String url = (a.attributes['href'] ?? '').trim();
        final String name = h5.text.trim();
        final String lastc =
            lastChapter.text.replaceAll(RegExp(r'[^0-9]'), '').trim();
        final String imageURL = (img.attributes['data-src'] ?? '').trim();
        final String? tag = element.querySelector('a span')?.text.trim();

        if (url.isNotEmpty && name.isNotEmpty && imageURL.isNotEmpty) {
          items.add(BookItem(
            id: toId(name),
            url: url,
            lastChapter: lastc,
            tag: tag,
            name: name,
            imageURL: imageURL,
          ));
        }
      }

      return items;
    } catch (_) {
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
      final Element? lastChapter =
          element.querySelector('span.chapter.font-meta');
      if (a == null || img == null || lastChapter == null) continue;

      final String url = (a.attributes['href'] ?? '').trim();
      final String lastc =
          lastChapter.text.replaceAll(RegExp(r'[^0-9]'), '').trim();
      final String name = a.text.trim();
      final String imageURL = (img.attributes['src'] ?? '').trim();

      final String? srcset = img.attributes['srcset'];
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
          lastChapter: lastc,
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
      return element.querySelector('h5')?.text.trim().toLowerCase() != 'type';
    });

    if (elements.isNotEmpty) {
      type = elements[0].querySelector('.summary-content')?.text.trim();
    }

    // Sinopse
    final String sinopse =
        document.querySelector('.summary__content')?.text.trim() ?? '';

    // Chapters
    elements = document.querySelectorAll('.main li a');
    for (Element element in elements) {
      element.querySelector('span')?.remove();

      final String url = (element.attributes['href'] ?? '').trim();
      final String name = element.text.trim();

      if (url.isNotEmpty && name.isNotEmpty) {
        final String id = Chapter.nameToId(name);

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
        document.querySelectorAll('.reading-content div');

    if (elements.isEmpty) {
      if (elementstext.isNotEmpty) {
        for (Element element in elementstext) {
          content.add(element.text);
        }
      }
    } else {
      for (Element element in elements) {
        final String url =
            (element.attributes['data-src'] ?? element.attributes['src'] ?? '')
                .trim();
        if (url.isNotEmpty) content.add(url);
      }
    }

    return content;
  }
}
