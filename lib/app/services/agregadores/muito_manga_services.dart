import 'package:com_joaojsrbr_reader/app/core/constants/strings.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/to_id.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class MuitoMangaServices {
  static String get baseURL => Strings.muitoMangaURL;

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
          document.querySelectorAll('#loadnews_here > div');

      for (Element element in elements) {
        final Element? a = element.querySelector('a');
        final Element? img = element.querySelector('img');
        final Element? lastChapter =
            element.querySelector('.lancamento-list li');
        if (a == null || img == null || lastChapter == null) continue;

        final String url = (a.attributes['href'] ?? '').trim();
        final String name = (img.attributes['title'] ?? '').trim();
        final String lastc =
            lastChapter.text.replaceAll(RegExp(r'[^0-9]'), '').trim();
        final String imageURL = (img.attributes['data-src'] ?? '').trim();

        if (url.isNotEmpty && name.isNotEmpty && imageURL.isNotEmpty) {
          items.add(BookItem(
            id: toId(name),
            url: baseURL + url,
            name: name,
            lastChapter: lastc,
            imageURL: imageURL,
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

    final String subKey = '?q=$value';
    final String url = '$baseURL/buscar$subKey';

    final Dio dio = Dio();
    final Options options = _cacheOptions(subKey: subKey);
    dio.interceptors.add(_cacheManager.interceptor);

    final Response response = await dio.get(url, options: options);
    final Document document = parse(response.data);

    final List<Element> elements =
        document.querySelectorAll('.content_post > div');

    for (Element element in elements) {
      final Element? a = element.querySelector('a');
      final Element? img = element.querySelector('img');
      if (a == null || img == null) continue;

      final String url = (a.attributes['href'] ?? '').trim();
      final String name = (img.attributes['title'] ?? '').trim();
      final String imageURL = (img.attributes['src'] ?? '').trim();

      if (url.isNotEmpty && name.isNotEmpty && imageURL.isNotEmpty) {
        items.add(
          BookItem(
            id: toId(name),
            url: baseURL + url,
            name: name,
            imageURL: imageURL,
          ),
        );
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
    List<Element> elements =
        document.querySelectorAll('ul.last-generos-series > li > a');

    for (var element in elements) {
      final String name = element.text.trim();
      if (name.isNotEmpty) categories.add(name);
    }

    // Sinopse
    final String sinopse =
        document.querySelector('.boxAnimeSobreLast > p')?.text.trim() ?? '';

    // Chapters
    elements = document.querySelectorAll('.manga-chapters > div > a');
    for (Element element in elements) {
      final url = (element.attributes['href'] ?? '').trim();
      final name = element.text.replaceAll('#', '').trim();

      if (url.isNotEmpty && name.isNotEmpty) {
        final String id = Chapter.nameToId(name);
        chapters.add(Chapter(id: id, url: baseURL + url, name: name));
      }
    }

    return Book(
      name: name,
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

    final RegExp exp = RegExp(r'"(https:.*?)"');
    final Iterable<RegExpMatch> matches = exp.allMatches(response.data);

    for (final RegExpMatch m in matches) {
      final String item = m[0].toString().replaceAll('\\/', '/');

      if (item.contains('imgs/')) content.add(item.replaceAll('"', ''));
    }

    return content;
  }
}
