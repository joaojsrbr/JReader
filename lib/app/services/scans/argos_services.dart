// ignore_for_file: unused_import, depend_on_referenced_packages

import 'dart:ffi';

import 'package:com_joaojsrbr_reader/app/core/constants/string.dart';
import 'package:com_joaojsrbr_reader/app/core/values/api_graphql_query.dart';
import 'package:com_joaojsrbr_reader/app/core/values/api_graphql_variables.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/models/chapter.dart';
import 'package:com_joaojsrbr_reader/app/models/from_json.dart';
import 'package:com_joaojsrbr_reader/app/services/session.dart';
import 'package:dio/dio.dart' as dior;
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;

class ArgosService {
  static HttpLink get baseApi => HttpLink(argosAPI);

  static Future<List<BookItem>> get popular async {
    final List<BookItem> tempList = [];
    try {
      final QueryOptions options = QueryOptions(
        document: gql(query),
        variables: variablesPopular(),
        // variables: variablesLatest(),
      );

      final QueryResult result = await _client(baseApi).query(options);

      for (var e in Data.fromJson(result.data!).getProjects!.projects!) {
        // String img = 'https://argosscan.com/img/${e.id}/${e.cover}';
        // String imageURL = 'https://argosscan.com/images/${e.id}/${e.cover}';
        // print(e.getChapters!.map((e) => (e.number ?? 0).toString()).single);
        final number =
            e.getChapters!.map((e) => (e.number ?? 0).toString()).singleWhere(
                  (element) => element.isNotEmpty,
                  orElse: () => '0',
                );

        tempList.add(
          BookItem(
            id: e.id.toString(),
            lastChapter: number,
            tag: e.type,
            name: e.name ?? '',
            url: 'https://argosscan.com/obras/${e.id}',
            imageURL: (e.cover == 'default.jpg')
                ? 'https://argosscan.com/img/default.jpg'
                : 'https://argosscan.com/images/${e.id}/${e.cover}',
            imageURL2: (e.cover == 'default.jpg')
                ? 'https://argosscan.com/img/default.jpg'
                : 'https://argosscan.com/images/${e.id}/${e.cover}',
          ),
        );
      }

      return tempList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  static Future<List<BookItem>> get lastAdded async {
    final List<BookItem> tempList = [];
    try {
      final QueryOptions options = QueryOptions(
        document: gql(query),
        // variables: variablesPopular(),
        variables: variablesLatest(),
      );

      final QueryResult result = await _client(baseApi).query(options);

      for (var e in Data.fromJson(result.data!).getProjects!.projects!) {
        // String img = 'https://argosscan.com/img/${e.id}/${e.cover}';
        // String imageURL = 'https://argosscan.com/images/${e.id}/${e.cover}';
        // print(e.getChapters!.last.title);
        final number =
            e.getChapters!.map((e) => (e.number ?? 0).toString()).singleWhere(
                  (element) => element.isNotEmpty,
                  orElse: () => '0',
                );
        tempList.add(
          BookItem(
            id: e.id.toString(),
            tag: e.type,
            lastChapter: number,
            name: e.name ?? '',
            url: 'https://argosscan.com/obras/${e.id}',
            imageURL: (e.cover == 'default.jpg')
                ? 'https://argosscan.com/img/default.jpg'
                : 'https://argosscan.com/images/${e.id}/${e.cover}',
            imageURL2: (e.cover == 'default.jpg')
                ? 'https://argosscan.com/img/default.jpg'
                : 'https://argosscan.com/images/${e.id}/${e.cover}',
          ),
        );
      }

      return tempList;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  // static Future<List<String>> getContent(String url) async {
  //   final List<String> content = [];

  //   final Dio dio = Dio();
  //   final Options options = _cacheOptions(subKey: url);
  //   dio.interceptors.add(_cacheManager.interceptor);

  //   final Response response = await dio.get(url, options: options);
  //   final Document document = parse(response.data);

  //   final List<Element> elements =
  //       document.querySelectorAll('.reading-content img');

  //   for (Element element in elements) {
  //     final String url = (element.attributes['data-src'] ?? '').trim();
  //     if (url.isNotEmpty) content.add(url);
  //   }

  //   return content;
  // }

  static Future<List<BookItem>> search(String value) async {
    final List<BookItem> items = [];

    // final String subKey = 'find/$value';
    // final String url = '$baseURL/$subKey';

    try {
      final QueryOptions options = QueryOptions(
        document: gql(query),
        variables: variablesSearch(value),
      );

      final QueryResult result = await _client(baseApi).query(options);

      for (var e in Data.fromJson(result.data!).getProjects!.projects!) {
        final number =
            e.getChapters!.map((e) => (e.number ?? 0).toString()).singleWhere(
                  (element) => element.isNotEmpty,
                  orElse: () => '0',
                );
        items.add(
          BookItem(
            id: e.id.toString(),
            tag: e.type,
            lastChapter: number,
            name: e.name ?? '',
            url: 'https://argosscan.com/obras/${e.id}',
            imageURL: (e.cover == 'default.jpg')
                ? 'https://argosscan.com/img/default.jpg'
                : 'https://argosscan.com/images/${e.id}/${e.cover}',
            imageURL2: (e.cover == 'default.jpg')
                ? 'https://argosscan.com/img/default.jpg'
                : 'https://argosscan.com/images/${e.id}/${e.cover}',
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return items;
  }

  static Future<List<String>> getContent(String url) async {
    final List<String> content = [];
    final QueryOptions options = QueryOptions(
      document: gql(querypage),
      variables: variablespage(url.split('/').last),
    );

    final QueryResult result = await _client(baseApi).query(options);
    final image =
        result.data!['getChapters']['chapters'][0]['images'] as List<Object?>;
    final id =
        result.data!['getChapters']['chapters'][0]['project']['id'] as int;
    for (var e in image) {
      content.add('https://argosscan.com/images/$id/$e');
    }

    return content;
  }

  static Future<Book> bookInfo(String url, String name) async {
    final List<Chapter> chapters = [];
    final List<String> categories = [];

    // if (kDebugMode) {
    //   print('title: $name - id: ${int.parse(url.split('/').last)}');
    // }

    try {
      final QueryOptions options = QueryOptions(
        document: gql(queryD),
        variables: variablesDbyId(int.parse(url.split('/').last)),
      );

      final QueryResult result = await _client(baseApi).query(options);

      final Data repositories = Data.fromJson(result.data!);

      // print(repositories);
      // type = repositories.type ?? '';

      for (var e in repositories.project!.getTags!) {
        categories.add(e.name ?? '');
      }

      // sinopse = repositories.description ?? '';
      for (var e in repositories.project!.getChapters!) {
        // if (kDebugMode) {
        //   print('url: https://argosscan.com/leitor/${e.id}');
        // }
        chapters.add(
          Chapter(
              id: e.id!,
              url: 'https://argosscan.com/leitor/${e.id}',
              name: e.title ?? ''),
        );
      }

      return Book(
        name: name,
        sinopse: repositories.project?.description ?? '',
        chapters: chapters,
        type: repositories.project?.type ?? '',
        categories: categories,
      );
    } catch (_) {
      return Book(
        name: name,
        sinopse: '',
        chapters: chapters,
        categories: categories,
      );
    }
  }

  static GraphQLClient _client(Link link) {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }
}
