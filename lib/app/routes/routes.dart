// ignore_for_file: constant_identifier_names

import 'package:com_joaojsrbr_reader/app/ui/book/screens/book_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/screens/favorites_destination.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/bindings/home_binding.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/screens/home_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/login/bindings/login_binding.dart';
import 'package:com_joaojsrbr_reader/app/ui/login/screens/login_screen.dart';
// import 'package:com_joaojsrbr_reader/app/ui/reader/bindings/reader_binding.dart';
import 'package:com_joaojsrbr_reader/app/ui/reader/screens/reader_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/search/bindings/search_binding.dart';
import 'package:com_joaojsrbr_reader/app/ui/search/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      curve: Curves.ease,
      name: RoutesName.LOGIN,
      transitionDuration: const Duration(milliseconds: 650),
      binding: LoginBinding(),
      page: () => const LoginScreen(),
    ),
    GetPage(
      curve: Curves.ease,
      name: RoutesName.HOME,
      binding: HomeBinding(),
      transitionDuration: const Duration(milliseconds: 650),
      page: () {
        return const HomeScreen();
      },
    ),
    GetPage(
      name: RoutesName.SEARCH,
      transitionDuration: const Duration(milliseconds: 650),
      page: () => const SearchScreen(),
      curve: Curves.ease,
      binding: SearchBinding(),
    ),
    GetPage(
      curve: Curves.ease,
      name: RoutesName.BOOK,
      transitionDuration: const Duration(milliseconds: 650),
      participatesInRootNavigator: true,
      page: () {
        return const BookScreen();
      },
    ),
    GetPage(
      curve: Curves.ease,
      name: RoutesName.READER,
      transitionDuration: const Duration(milliseconds: 650),
      // binding: ReaderBinding(),
      // page: () => const ReaderScreen2(),
      page: () {
        return const ReaderScreen();
      },
    ),
    GetPage(
      name: RoutesName.FAVORITES,
      curve: Curves.ease,
      transitionDuration: const Duration(milliseconds: 650),
      page: () => const FavoritesDestination(),
    ),
  ];
}
