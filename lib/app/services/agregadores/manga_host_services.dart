import 'package:com_joaojsrbr_reader/app/core/constants/strings.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/get_image.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:dio/dio.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/to_id.dart';

import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class MangaHostServices {
  static String get baseURL1 => Strings.mangaHostURL1;
  static String get baseURL2 => Strings.mangaHostURL2;
  static String get baseURL3 => Strings.mangaHostURL3;

  static DioCacheManager _cacheManager(String baseUrl) {
    return DioCacheManager(CacheConfig(baseUrl: baseUrl));
  }

  static String baseUrlByUrl(String url) {
    if (url.contains(baseURL2)) return baseURL2;
    if (url.contains(baseURL3)) return baseURL3;
    return baseURL1;
  }

  static bool isMH(String url) {
    return url.contains(baseURL1) ||
        url.contains(baseURL2) ||
        url.contains(baseURL3);
  }

  static Map<String, String> headers(
    String url, {
    String? referer,
  }) {
    String baseURL = baseUrlByUrl(url);
    // final String referer1 = 'baseURL/find/$referer' ?? baseURL;
    return {
      'Origin': baseURL,
      'Referer': referer ?? baseURL,
      'accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'upgrade-insecure-requests': '1',
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.5112.102 Safari/537.36',
    };
  }

  static Options _cacheOptions({required String url, String? subKey}) {
    return buildCacheOptions(
      const Duration(days: 15),
      subKey: subKey,
      forceRefresh: true,
      options: Options(headers: headers(url)),
    );
  }

  static Future<List<BookItem>> get lastAdded async {
    List<BookItem> items = [];
    String baseURL = baseURL1;

    do {
      try {
        final Dio dio = Dio();
        final Options options = Options(headers: headers(baseURL));

        final Response response = await dio.get(baseURL, options: options);
        final Document document = parse(response.data);

        final List<Element> elements =
            document.querySelectorAll('#dados .lejBC.w-row');

        for (Element element in elements) {
          final Element? a = element.querySelector('h4 a');
          final Element? img = element.querySelector('img');
          final Element? lastChapter = element.querySelector('.chapters a');
          final Element? source = element.querySelector('source');
          if (a == null ||
              (source == null && img == null) ||
              lastChapter == null) {
            continue;
          }

          final String url = (a.attributes['href'] ?? '').trim();
          final String name = a.text.trim();
          final String lastc =
              lastChapter.text.replaceAll(RegExp(r'[^0-9]'), '').trim();
          final String imageURL = (source?.attributes['srcset'] ?? '')
              .trim()
              .replaceAll(r'xmedium', 'full');
          final String imageURL2 = (img?.attributes['src'] ?? '')
              .trim()
              .replaceAll(r'xmedium', 'full');

          final bool is18 = element.querySelector('.age-18') != null;

          final bool hasImage = imageURL.isNotEmpty || imageURL2.isNotEmpty;

          if (url.isNotEmpty && name.isNotEmpty && hasImage && !is18) {
            items.add(
              BookItem(
                id: toId(name),
                url: url,
                name: name,
                is18: is18,
                lastChapter: lastc,
                headers: headers(url),
                imageURL: imageURL.isEmpty ? imageURL2 : imageURL,
                imageURL2: imageURL2,
              ),
            );
          }
        }
      } catch (e) {
        if (baseURL == baseURL1) {
          baseURL = baseURL2;
        } else if (baseURL == baseURL2) {
          baseURL = baseURL3;
        } else if (baseURL == baseURL3) {
          break;
        }

        items = [];
      }
    } while (items.isEmpty);

    return items;
  }

  static Future<List<BookItem>> search(String value) async {
    List<BookItem> items = [];
    String baseURL = baseURL1;

    do {
      try {
        final String subKey = 'find/$value';
        final String urlr = '$baseURL/$subKey';

        final Dio dio = Dio();
        final Options options =
            Options(headers: headers(baseURL, referer: urlr));

        final Response response = await dio.get(urlr, options: options);
        final Document document = parse(response.data);

        final List<Element> elements = document.querySelectorAll('main tr');

        for (Element element in elements) {
          final Element? a = element.querySelector('h4 a');
          final Element? img = element.querySelector('img');
          final Element? source = element.querySelector('source');
          if (a == null || (source == null && img == null)) continue;

          final String url = (a.attributes['href'] ?? '').trim();
          final String name = a.text.trim();
          final String imageURL = (source?.attributes['srcset'] ?? '').trim();
          final String imageURL2 = (img?.attributes['src'] ?? '').trim();

          if (url.isNotEmpty &&
              name.isNotEmpty &&
              (imageURL.isNotEmpty || imageURL2.isNotEmpty)) {
            items.add(
              BookItem(
                id: toId(name),
                url: url,
                name: name,
                headers: headers(url),
                imageURL: imageURL.isEmpty ? imageURL2 : imageURL,
                imageURL2: imageURL2,
              ),
            );
          }
        }
      } catch (_) {
        if (baseURL == baseURL1) {
          baseURL = baseURL2;
        } else if (baseURL == baseURL2) {
          baseURL = baseURL3;
        } else if (baseURL == baseURL3) {
          break;
        }

        items = [];
      }
    } while (items.isEmpty);

    return items;
  }

  static Future<Book> bookInfo(String url, String name) async {
    String bookURL = url;
    Book? book;

    int numberOfAttempts = 0;

    while (numberOfAttempts < 3) {
      numberOfAttempts++;

      try {
        final Dio dio = Dio();
        final Options options = Options(headers: headers(bookURL));
        final Response response = await dio.get(bookURL, options: options);
        final Document document = parse(response.data);

        final List<Chapter> chapters = [];
        final List<String> categories = [];

        // Categories
        List<Element> elements = document.querySelectorAll('div.tags a.tag');
        for (Element element in elements) {
          final String name = element.text.trim();
          if (name.isNotEmpty) categories.add(name);
        }

        // Type
        String? type;
        elements = document.querySelectorAll('div.text ul li');
        elements.removeWhere((element) {
          final Element? strong = element.querySelector('strong');
          return strong?.text.trim().toLowerCase() != 'tipo:';
        });

        if (elements.isNotEmpty) {
          final String value =
              elements[0].querySelector('div')?.text.trim() ?? '';
          type = value.isEmpty ? null : value.replaceAll('Tipo: ', '').trim();
        }

        // Sinopse
        final String sinopse =
            document.querySelector('div.text .paragraph')?.text.trim() ?? '';

        // Chapters
        elements = document.querySelectorAll('section div.chapters div.cap');
        for (Element element in elements) {
          final a = element.querySelector('.tags a');
          if (a == null) continue;

          final String url = (a.attributes['href'] ?? '').trim();
          final String name =
              element.querySelector('a[rel]')?.text.trim() ?? '';

          if (url.isNotEmpty && name.isNotEmpty) {
            final double? episode = double.tryParse(name);
            final String capName =
                episode != null ? 'Cap. ${name.padLeft(2, '0')}' : name;

            final String id = Chapter.nameToId(name);
            chapters.add(Chapter(id: id, url: url, name: capName));
          }
        }

        book = Book(
          name: name,
          type: type,
          sinopse: sinopse,
          chapters: chapters,
          categories: categories,
        );
        break;
      } catch (_) {
        if (url.contains('mangahosted')) {
          bookURL = bookURL.replaceAll('mangahosted', baseURL2);
        } else if (url.contains('mangahostz')) {
          bookURL = bookURL.replaceAll('mangahost4', baseURL1);
        } else if (url.contains('mangahostz')) {
          bookURL = bookURL.replaceAll('mangahostz', baseURL3);
        }

        // if (url.contains('mangahostz')) {
        //   bookURL = bookURL.replaceAll('mangahostz', 'mangahost4');
        // }
        // if (url.contains('mangahost4')) {
        //   bookURL = bookURL.replaceAll('mangahost4', 'mangahosted');
        // }
        // if (url.contains('mangahosted')) {
        //   bookURL = bookURL.replaceAll('mangahosted', 'mangahostz');
        // }
      }
    }

    if (book == null) throw Error();
    return book;
  }

  static Future<List<String>> getContent(String url) async {
    final String baseURL = baseUrlByUrl(url);
    final List<String> content = [];

    final Dio dio = Dio();
    final Options options = _cacheOptions(url: baseURL, subKey: url);
    dio.interceptors.add(_cacheManager(baseURL).interceptor);

    final Response response = await dio.get(url, options: options);
    final Document document = parse(response.data);

    final List<Element> elements = document.querySelectorAll('#slider a img');

    for (Element element in elements) {
      final String url = GetImage.bySrc(element);
      if (url.isNotEmpty) content.add(url);
    }

    return content;
  }
}
