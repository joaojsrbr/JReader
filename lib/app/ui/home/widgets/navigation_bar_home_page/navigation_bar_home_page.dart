import 'package:state_change/state_change.dart';
import 'package:flutter/material.dart';

class NavigationBarHomePage extends StatelessWidget {
  const NavigationBarHomePage({
    super.key,
    required this.onDestinationSelected,
    required this.selectedIndex,
  });
  final Function(int)? onDestinationSelected;
  final ValueNotifier<int> selectedIndex;

  @override
  Widget build(BuildContext context) {
    return StateChange<int>(
      notifier: selectedIndex,
      builder: (context, value) => NavigationBarTheme(
        data: NavigationBarThemeData(
          surfaceTintColor: const Color(0xff000000),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: value,
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
        ),
      ),
    );
  }
}
