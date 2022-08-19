import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/argos_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/cronos_services.dart';
import 'package:com_joaojsrbr_reader/app/services/agregadores/manga_host_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/mark_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/neox_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/olympus_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/prisma_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/random_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/reaper_services.dart';

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
