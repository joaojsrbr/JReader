String? taginfo(String url) {
  // print(url);
  if (url.contains('neoxscans')) {
    return 'NEOX';
  } else if (url.contains('randomscan')) {
    return 'RANDOM';
  } else if (url.contains('markscans')) {
    return 'MARK';
  } else if (url.contains('cronosscan')) {
    return 'CRONOS';
  } else if (url.contains('prismascans')) {
    return 'PRISMA';
  } else if (url.contains('reaperscans')) {
    return 'REAPER';
  } else if (url.contains('img-host') || url.contains('mangahost4')) {
    return 'MANGAHOST';
  } else if (url.contains('argosscan')) {
    return 'ARGOS';
  } else if (url.contains('olympusscanlation')) {
    return 'Olympusscanlation'.toUpperCase();
  } else if (url.contains('muitomanga')) {
    return 'muitomanga'.toUpperCase();
  }
  return '';
}
