class BookItem {
  final String id;
  final String url;
  final String? tag;
  final String name;
  final String imageURL;
  final String? imageURL2;
  final Map<String, String>? headers;
  final bool? is18;

  const BookItem({
    required this.id,
    required this.url,
    required this.name,
    required this.imageURL,
    this.imageURL2,
    this.headers,
    this.is18,
    this.tag,
  });

  Map<String, String?> get toMap {
    return {
      'id': id,
      'url': url,
      'tag': tag,
      'name': name,
      'imageURL': imageURL,
      'imageURL2': imageURL2,
    };
  }
}
