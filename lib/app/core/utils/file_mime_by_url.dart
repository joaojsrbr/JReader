String fileMimeByUrl(String url) {
  return url.split('.').reversed.first.trim();
}
