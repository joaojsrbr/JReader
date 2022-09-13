// ignore_for_file: constant_identifier_names

import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/repository/repository.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

enum Providers {
  All,
  NEOX,
  RANDOM,
  MARK,
  CRONOS,
  PRISMA,
  REAPER,
  MANGA_HOST,
  ARGOS,
  OLYMPUS,
  MUITO_MANGA,
}

extension StringsP on List<Providers> {
  List<String> strings() {
    final maptemp = map((e) => e.string).toList();
    maptemp.remove('All');
    return maptemp;
  }
}

extension StringScan on ValueNotifier<LoadingMoreBase<BookItem>> {
  void scan(String value, Repository repository) {
    switch (value) {
      case 'Neox':
        this.value = repository.lista[0];
        break;
      case 'Mark':
        this.value = repository.lista[1];
        break;
      case 'Random':
        this.value = repository.lista[2];
        break;
      case 'Cronos':
        this.value = repository.lista[3];
        break;
      case 'Prisma':
        this.value = repository.lista[4];
        break;
      case 'Reaper':
        this.value = repository.lista[5];
        break;
      case 'Manga Host':
        this.value = repository.lista[6];
        break;
      case 'Argos':
        this.value = repository.lista[7];
        break;
      case 'Olympus':
        this.value = repository.lista[8];
        break;
      case 'Muito Mangá':
        this.value = repository.lista[9];
        break;
    }
  }
}

extension ProvidersExtension on Providers {
  String get string {
    switch (this) {
      case Providers.All:
        return 'All';

      case Providers.NEOX:
        return 'Neox';

      case Providers.RANDOM:
        return 'Random';

      case Providers.MARK:
        return 'Mark';

      case Providers.CRONOS:
        return 'Cronos';

      case Providers.PRISMA:
        return 'Prisma';

      case Providers.REAPER:
        return 'Reaper';

      case Providers.MANGA_HOST:
        return 'Manga Host';

      case Providers.ARGOS:
        return 'Argos';

      case Providers.OLYMPUS:
        return 'Olympus';

      case Providers.MUITO_MANGA:
        return 'Muito Mangá';
    }
  }
}
