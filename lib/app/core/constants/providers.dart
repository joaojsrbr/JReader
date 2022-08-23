// ignore_for_file: constant_identifier_names

enum Providers {
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

extension ProvidersExtension on Providers {
  String get string {
    switch (this) {
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
