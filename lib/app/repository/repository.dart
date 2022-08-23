import 'package:collection/collection.dart';
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

  static LoadingMoreBase<BookItem> neox = NeoxSource();
  static LoadingMoreBase<BookItem> mark = MarkSource();
  static LoadingMoreBase<BookItem> random = RandomSource();
  static LoadingMoreBase<BookItem> cronos = CronosSource();
  static LoadingMoreBase<BookItem> prisma = PrismaSource();
  static LoadingMoreBase<BookItem> reaper = ReaperSource();
  static LoadingMoreBase<BookItem> mangahost = MangaHostSource();
  static LoadingMoreBase<BookItem> argos = ArgosSource();
  static LoadingMoreBase<BookItem> olympus = OlympusSource();
  static LoadingMoreBase<BookItem> muitomanga = MuitoMangaSource();
}
