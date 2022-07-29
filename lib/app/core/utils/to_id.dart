import 'package:slugify/slugify.dart';

String toId(String value) {
  return slugify(value.trim(), lowercase: true, delimiter: '_');
}
