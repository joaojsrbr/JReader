// ignore: constant_identifier_names
enum Providers { NEOX, RANDOM, MARK, CRONOS, PRISMA, REAPER, MANGA_HOST, ARGOS }

extension ProvidersExtension on Providers {
  String get value {
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
    }
  }
}
