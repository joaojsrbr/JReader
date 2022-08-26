import 'package:com_joaojsrbr_reader/app/widgets/inherited_widget.dart';
import 'package:flutter/material.dart';

class NavigationBarHomePage extends StatelessWidget {
  const NavigationBarHomePage({
    super.key,
    required this.onDestinationSelected,
  });
  final Function(int)? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final value = InheritedWidgetValueNotifier.of<int>(context).value as int;
    return NavigationBar(
      height: 60,
      selectedIndex: value,
      backgroundColor: Theme.of(context).colorScheme.background,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(
            Icons.home_rounded,
          ),
          label: "Home",
          icon: Icon(
            Icons.home_outlined,
          ),
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.favorite_rounded,
          ),
          label: "Favorito",
          icon: Icon(
            Icons.favorite_border_rounded,
          ),
        ),
      ],
    );
  }
}
