// ignore_for_file: public_member_api_docs, sort_constructors_first
class Chapter {
  final String id;
  final String url;
  final String name;
  final String? bookId;
  final double? position;

  const Chapter({
    required this.id,
    required this.url,
    required this.name,
    this.bookId,
    this.position,
  });

  Map<String, Object?> get toMap {
    return {
      'id': id,
      'url': url,
      'name': name,
      'position': position,
    };
  }

  static String nameToId(String name) {
    final String id = name
        .toLowerCase()
        .replaceAll('cap.', '')
        .replaceAll(RegExp(r'[^0-9.]'), '')
        .replaceAll('.', '_');

    final List<String> splitId = id.split('_');
    final int first = int.parse(splitId[0]);
    final String formattedFirst = first <= 9 ? '0$first' : first.toString();

    splitId.removeAt(0);

    return [formattedFirst, ...splitId].join('_');
  }

  @override
  bool operator ==(covariant Chapter other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.url == url &&
        other.name == name &&
        other.bookId == bookId &&
        other.position == position;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        url.hashCode ^
        name.hashCode ^
        bookId.hashCode ^
        position.hashCode;
  }
}
