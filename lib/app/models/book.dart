import 'package:com_joaojsrbr_reader/app/models/chapter.dart';

class Book {
  final String name;
  final String? type;

  final String sinopse;
  final List<String> categories;
  final List<Chapter> chapters;

  const Book({
    required this.name,
    required this.sinopse,
    required this.chapters,
    required this.categories,
    this.type,
  });

  String get totalChapters {
    if (chapters.isEmpty) return '00';

    final String lastChapter = chapters.first.name;
    final String totalChapter = lastChapter
        .toLowerCase()
        .replaceAll('cap.', '')
        .replaceAll(RegExp(r'(\([0-9]\))'), '')
        .replaceAll(RegExp(r'[^0-9.]'), '')
        .replaceAll(RegExp(r','), '.')
        .split('.')
        .first
        .padLeft(2, '0');

    return totalChapter;
  }
}
