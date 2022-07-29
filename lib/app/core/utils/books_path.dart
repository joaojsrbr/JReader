import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BooksPath {
  static Future<String> get rootPath async {
    final documentDir = await getExternalStorageDirectory();
    return documentDir?.path ?? '';
  }

  static Future<Directory?> get rootDir async {
    final documentDir = await getExternalStorageDirectory();
    return documentDir;
  }

  static Future<Directory> book(String bookId) async {
    final String path = await rootPath;
    return Directory('$path/$bookId');
  }

  static Future<Map<String, dynamic>> getChapters(String bookId) async {
    final Directory directory = await book(bookId);
    if (!directory.existsSync()) return {};

    final List<FileSystemEntity> folders = directory.listSync();
    final Map<String, dynamic> chapters = {};

    for (FileSystemEntity folder in folders) {
      final Directory folderDir = Directory(folder.path);
      if (folderDir.listSync().isEmpty) continue;

      final name = basename(folder.path);
      chapters[name] = null;
    }

    return chapters;
  }

  static Future<List<String>> getContent(String bookId, String chapter) async {
    Directory directory = await book(bookId);
    directory = Directory('${directory.path}/$chapter');

    if (!directory.existsSync()) return [];

    final List<FileSystemEntity> items = directory.listSync();
    final List<String> paths = items.map((item) => item.path).toList();
    paths.sort(compareNatural);

    return paths.map((path) {
      final Uint8List imageBytes = File(path).readAsBytesSync();
      return 'data:image/*;base64,${base64.encode(imageBytes)}';
    }).toList();
  }
}
