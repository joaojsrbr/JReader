import 'package:com_joaojsrbr_reader/app/core/constants/strings.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/get_image.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/to_id.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class MarkServices {
  static String get baseURL => Strings.markURL;

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
        final Element? lastChapter =
            element.querySelector('span.chapter.font-meta');
        if (a == null || img == null || lastChapter == null) continue;

        final String lastc =
            lastChapter.text.replaceAll(RegExp(r'[^0-9]'), '').trim();
        final String url = (a.attributes['href'] ?? '').trim();
        final String name = a.text.trim();
        final String? tag =
            element.querySelector('span.manga-type')?.text.trim();

        final String imageURL = GetImage.bySrc(img);
        final String? imageURL2 = GetImage.bySrcSet(img);

        if (url.isNotEmpty && name.isNotEmpty && imageURL.isNotEmpty) {
          items.add(
            BookItem(
              id: toId(name),
              url: url,
              tag: tag,
              lastChapter: lastc,
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
      final Element? lastChapter =
          element.querySelector('span.chapter.font-meta');
      if (a == null || img == null || lastChapter == null) continue;

      final String url = (a.attributes['href'] ?? '').trim();
      final String name = a.text.trim();
      final String lastc =
          lastChapter.text.replaceAll(RegExp(r'[^0-9]'), '').trim();

      final String imageURL = GetImage.bySrc(img);
      final String? imageURL2 = GetImage.bySrcSet(img);

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
    Dio dio = Dio();
    Options options = _cacheOptions(subKey: url, forceRefresh: false);
    dio.interceptors.add(_cacheManager.interceptor);

    Response response = await dio.get(url, options: options);
    Document document = parse(response.data);

    final List<Chapter> chapters = [];
    final List<String> categories = [];

    // Categories
    List<Element> elements = document.querySelectorAll('.genres-content a');
    for (Element element in elements) {
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
    final String sinopse = document
            .querySelector('.description-summary > .post-content_item')
            ?.text
            .trim() ??
        '';

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
          final String id = Chapter.nameToId(name);
          chapters.add(
            Chapter(id: id, url: url, name: name),
          );
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
    final Element? elementstext =
        document.querySelector('.reading-content div');
    if (elements.isEmpty) {
      if (elementstext != null) {
        for (Element element in elementstext.children) {
          content.add(element.text);
        }
      }
    } else {
      for (Element element in elements) {
        final String url = GetImage.bySrc(element);
        if (url.isNotEmpty) content.add(url);
      }
    }
    return content;
  }
}
