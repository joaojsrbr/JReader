import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/argos_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/cronos_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/manga_host_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/mark_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/neox_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/prisma_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/random_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/reaper_services.dart';

Future<List<BookItem>> search(String value) async {
  List<BookItem> results = [];

  results.addAll(await _search(NeoxServices.search(value)));

  results.addAll(await _search(RandomServices.search(value)));

  results.addAll(await _search(MarkServices.search(value)));

  results.addAll(await _search(CronosServices.search(value)));

  results.addAll(await _search(PrismaServices.search(value)));

  results.addAll(await _search(ReaperServices.search(value)));

  results.addAll(await _search(MangaHostServices.search(value)));

  results.addAll(await _search(ArgosService.search(value)));

  // if (provider == Providers.NEOX) {
  //   results = await NeoxServices.search(value);
  // } else if (provider == Providers.RANDOM) {
  //   results = await RandomServices.search(value);
  // } else if (provider == Providers.MARK) {
  //   results = await MarkServices.search(value);
  // } else if (provider == Providers.CRONOS) {
  //   results = await CronosServices.search(value);
  // } else if (provider == Providers.PRISMA) {
  //   results = await PrismaServices.search(value);
  // } else if (provider == Providers.REAPER) {
  //   results = await ReaperServices.search(value);
  // } else if (provider == Providers.MANGA_HOST) {
  //   results = await MangaHostServices.search(value);
  // } else if (provider == Providers.ARGOS) {
  //   results = await ArgosService.search(value);
  // }

  return results;
}

Future<List<BookItem>> _search(Future<List<BookItem>> value) async {
  var templist = await value;
  if (templist.isEmpty) {
    return [];
  } else {
    return templist;
  }
}
