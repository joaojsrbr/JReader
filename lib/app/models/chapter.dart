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
}
