import 'package:com_joaojsrbr_reader/app/services/scans/argos_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/cronos_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/manga_host_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/mark_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/neox_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/prisma_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/random_services.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/reaper_services.dart';

Future<List<String>> bookContent(String url) async {
  if (url.contains('neoxscans')) {
    return NeoxServices.getContent(url);
  } else if (url.contains('randomscan')) {
    return RandomServices.getContent(url);
  } else if (url.contains('markscans')) {
    return MarkServices.getContent(url);
  } else if (url.contains('cronosscan')) {
    return await CronosServices.getContent(url);
  } else if (url.contains('prismascans')) {
    return await PrismaServices.getContent(url);
  } else if (url.contains('reaperscans')) {
    return await ReaperServices.getContent(url);
  } else if (url.contains('mangahosted') || url.contains('mangahost4')) {
    return MangaHostServices.getContent(url);
  } else if (url.contains('argosscan')) {
    return ArgosService.getContent(url);
  }

  return [];
}
