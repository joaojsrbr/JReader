import 'package:com_joaojsrbr_reader/app/core/constants/providers.dart';
import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';

class PopupMenuButtonHomepage extends StatelessWidget {
  const PopupMenuButtonHomepage({
    super.key,
    required this.onSelected,
  });

  final Function(Providers) onSelected;

  @override
  Widget build(BuildContext context) {
    final value =
        InheritedWidgetValueNotifier.of<Providers>(context).value as Providers;
    // print('PopupMenuButtonHomepage');
    return PopupMenuButton<Providers>(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Theme.of(context).colorScheme.background,
      // enabled: !controller.itemBookRepository.isLoading,
      icon: const Icon(Icons.menu_rounded),
      initialValue: value,
      onSelected: onSelected,
      padding: const EdgeInsets.only(right: 12),
      itemBuilder: (ctx) => <PopupMenuEntry<Providers>>[
        const PopupMenuItem(
          value: Providers.NEOX,
          child: Text('Neox'),
        ),
        const PopupMenuItem(
          value: Providers.RANDOM,
          child: Text('Random'),
        ),
        const PopupMenuItem(
          value: Providers.MARK,
          child: Text('Mark'),
        ),
        const PopupMenuItem(
          value: Providers.CRONOS,
          child: Text('Cronos'),
        ),
        const PopupMenuItem(
          value: Providers.PRISMA,
          child: Text('Prisma'),
        ),
        const PopupMenuItem(
          value: Providers.REAPER,
          child: Text('Reaper'),
        ),
        const PopupMenuItem(
          value: Providers.MANGA_HOST,
          child: Text('Manga Host'),
        ),
        const PopupMenuItem(
          value: Providers.ARGOS,
          child: Text('Argos'),
        ),
        const PopupMenuItem(
          value: Providers.OLYMPUS,
          child: Text('Olympus'),
        ),
        const PopupMenuItem(
          value: Providers.MUITO_MANGA,
          child: Text('Muito Manga'),
        ),
      ],
    );
  }
}
