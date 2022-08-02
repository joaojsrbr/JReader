// ignore_for_file: constant_identifier_names

import 'package:com_joaojsrbr_reader/app/modules/favorites/bindings/favorites_binding.dart';
import 'package:com_joaojsrbr_reader/app/modules/home/bindings/home_binding.dart';
import 'package:com_joaojsrbr_reader/app/modules/about/screens/about_screen.dart';
import 'package:com_joaojsrbr_reader/app/modules/book/screens/book_screen.dart';
import 'package:com_joaojsrbr_reader/app/modules/favorites/screens/favorites_screen.dart';
import 'package:com_joaojsrbr_reader/app/modules/home/screens/home_screen.dart';
import 'package:com_joaojsrbr_reader/app/modules/login/bindings/login_binding.dart';
import 'package:com_joaojsrbr_reader/app/modules/login/screens/login_screen.dart';
import 'package:com_joaojsrbr_reader/app/modules/reader/screens/reader_screen.dart';
// import 'package:com_joaojsrbr_reader/app/modules/reader/screens/reader_screen.dart';
import 'package:com_joaojsrbr_reader/app/modules/search/bindings/search_binding.dart';
import 'package:com_joaojsrbr_reader/app/modules/search/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomPageRoute<T> extends PageRoute<T> {
  final Widget child;

  CustomPageRoute(this.child);

  @override
  Color get barrierColor => Colors.black;

  @override
  String get barrierLabel => '';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 600);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class RoutesName {
  static const LOGIN = '/login';
  static const HOME = '/home';

  static const BOOK = '/book';
  static const ABOUT = '/about';
  static const READER = '/reader';
  static const SEARCH = '/search';
  static const FAVORITES = '/favorites';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      curve: Curves.linear,
      name: RoutesName.LOGIN,
      binding: LoginBinding(),
      page: () => const LoginScreen(),
    ),
    GetPage(
      curve: Curves.linear,
      name: RoutesName.HOME,
      binding: HomeBinding(),
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: RoutesName.SEARCH,
      page: () => const SearchScreen(),
      curve: Curves.linear,
      binding: SearchBinding(),
    ),
    GetPage(
      curve: Curves.linear,
      name: RoutesName.BOOK,
      page: () => const BookScreen(),
    ),
    GetPage(
      curve: Curves.linear,

      name: RoutesName.READER,
      // page: () => const ReaderScreen(),
      page: () => const ReaderScreen(),
      // binding: ReaderBinding(),
    ),
    GetPage(
      name: RoutesName.FAVORITES,
      curve: Curves.linear,
      page: () => const FavoritesScreen(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      curve: Curves.linear,
      name: RoutesName.ABOUT,
      page: () => const AboutScreen(),
    ),
  ];
}
