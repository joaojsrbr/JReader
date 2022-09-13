import 'dart:collection';

import 'package:com_joaojsrbr_reader/app/core/constants/providers.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/repository/source/argos_source.dart';
import 'package:com_joaojsrbr_reader/app/repository/source/cronos_source.dart';
import 'package:com_joaojsrbr_reader/app/repository/source/mangahost_source.dart';
import 'package:com_joaojsrbr_reader/app/repository/source/mark_source.dart';
import 'package:com_joaojsrbr_reader/app/repository/source/muitomanga_source.dart';
import 'package:com_joaojsrbr_reader/app/repository/source/neox_source.dart';
import 'package:com_joaojsrbr_reader/app/repository/source/olympus_source.dart';
import 'package:com_joaojsrbr_reader/app/repository/source/prisma_source.dart';
import 'package:com_joaojsrbr_reader/app/repository/source/random_source.dart';
import 'package:com_joaojsrbr_reader/app/repository/source/reaper_source.dart';
import 'package:com_joaojsrbr_reader/app/services/scans/export_scans.dart';
import 'package:loading_more_list/loading_more_list.dart';

class Repository {
  Repository() {
    oninit();
  }

  late List<LoadingMoreBase<BookItem>> _lista;

  void oninit() {
    _lista = [
      NeoxSource(),
      MarkSource(),
      RandomSource(),
      CronosSource(),
      PrismaSource(),
      ReaperSource(),
      MangaHostSource(),
      ArgosSource(),
      OlympusSource(),
      MuitoMangaSource(),
    ];
  }

  late final UnmodifiableListView<LoadingMoreBase<BookItem>> lista =
      UnmodifiableListView(_lista);

  static Future<List<BookItem>> bookLastAdded(Providers provider) async {
    switch (provider) {
      case Providers.NEOX:
        return NeoxServices.lastAdded;

      case Providers.RANDOM:
        return RandomServices.lastAdded;

      case Providers.MARK:
        return MarkServices.lastAdded;

      case Providers.CRONOS:
        return CronosServices.lastAdded;

      case Providers.PRISMA:
        return PrismaServices.lastAdded;

      case Providers.REAPER:
        return ReaperServices.lastAdded;

      case Providers.OLYMPUS:
        return OlympusServices.lastAdded;

      case Providers.MANGA_HOST:
        return MangaHostServices.lastAdded;

      case Providers.MUITO_MANGA:
        return MuitoMangaServices.lastAdded;

      case Providers.ARGOS:
        return ArgosService.popular;

      default:
        return [];
    }
  }
}
