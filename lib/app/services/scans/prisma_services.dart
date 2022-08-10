import 'package:com_joaojsrbr_reader/app/core/constants/url.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/to_id.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class PrismaServices {
  static String get baseURL => prismaURL;

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
          document.querySelectorAll('#loop-content .page-item-detail');

      for (Element element in elements) {
        final Element? a = element.querySelector('h3 a');
        final Element? img = element.querySelector('img');
        if (a == null || img == null) continue;

        final String url = (a.attributes['href'] ?? '').trim();
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
            imageURL: imageURL,
            imageURL2: imageURL2,
          ));
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
          imageURL: imageURL,
          imageURL2: imageURL2,
        ));
      }
    }

    return items;
  }

  static Future<Book> bookInfo(String url, String name) async {
    final Dio dio = Dio();
    Options options = _cacheOptions(subKey: url, forceRefresh: false);
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
        document.querySelector('.summary__content')?.text.trim() ?? '';

    // Chapters
    try {
      final String chapterURL = '$url/ajax/chapters'.replaceAll('//a', '/a');
      options = _cacheOptions(subKey: chapterURL);

      response = await dio.post(chapterURL, options: options);
      document = parse(response.data);

      elements = document.querySelectorAll('ul.main > li.wp-manga-chapter > a');
      for (Element element in elements) {
        final String url = (element.attributes['href'] ?? '').trim();
        final String name = element.text.trim();

        if (url.isNotEmpty && name.isNotEmpty) {
          final String id = name
              .toLowerCase()
              .replaceAll('cap.', '')
              .replaceAll(RegExp(r'[^0-9.]'), '')
              .replaceAll('.', '_');

          chapters.add(Chapter(id: id, url: url, name: name));
        }
      }
    } catch (_) {}

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

    for (Element element in elements) {
      final String url = (element.attributes['src'] ?? '').trim();
      if (url.isNotEmpty) content.add(url);
    }

    return content;
  }
}
