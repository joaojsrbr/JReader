import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/agregadores/muito_manga_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/argos_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/cronos_services.dart';
import 'package:com_joaojsrbr_reader/app/services/agregadores/manga_host_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/mark_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/neox_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/olympus_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/prisma_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/random_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/reaper_services.dart';

Future<List<BookItem>> searchByUrl(String url, String name) async {
  if (url.contains('neoxscans')) {
    return NeoxServices.search(name);
  } else if (url.contains('randomscan')) {
    return RandomServices.search(name);
  } else if (url.contains('markscans')) {
    return MarkServices.search(name);
  } else if (url.contains('cronosscan')) {
    return await CronosServices.search(name);
  } else if (url.contains('prismascans')) {
    return await PrismaServices.search(name);
  } else if (url.contains('reaperscans')) {
    return await ReaperServices.search(name);
  } else if (url.contains('mangahosted') ||
      url.contains('mangahostz') ||
      url.contains('mangahost4')) {
    return MangaHostServices.search(name);
  } else if (url.contains('argosscan')) {
    return ArgosService.search(name);
  } else if (url.contains('olympusscanlation')) {
    return await OlympusServices.search(name);
  } else if (url.contains('muitomanga')) {
    return await MuitoMangaServices.search(name);
  }
  return [];
}

Future<List<BookItem>> search(String value) async {
  final String result = value.trimRight();
  List<BookItem> results = [];

  results.addAll(await _search(NeoxServices.search(result)));

  results.addAll(await _search(RandomServices.search(result)));

  results.addAll(await _search(MarkServices.search(result)));

  results.addAll(await _search(CronosServices.search(result)));

  results.addAll(await _search(PrismaServices.search(result)));

  results.addAll(await _search(ReaperServices.search(result)));

  results.addAll(await _search(OlympusServices.search(result)));

  results.addAll(await _search(ArgosService.search(result)));

  results.addAll(await _search(MuitoMangaServices.search(result)));

  results.addAll(await _search(MangaHostServices.search(result)));

  return results;
}

Future<List<BookItem>> _search(Future<List<BookItem>> value) async {
  List<BookItem> templist = [];
  value.then(
    (value) {
      templist = value;
    },
  );
  // templist = await value;
  if (templist.isEmpty) {
    return [];
  } else {
    return templist;
  }
}
