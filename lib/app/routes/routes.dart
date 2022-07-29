// ignore_for_file: constant_identifier_names

import 'package:A.N.R/app/modules/favorites/bindings/favorites_binding.dart';
import 'package:A.N.R/app/modules/home/bindings/home_binding.dart';
import 'package:A.N.R/app/modules/about/screens/about_screen.dart';
import 'package:A.N.R/app/modules/book/screens/book_screen.dart';
import 'package:A.N.R/app/modules/favorites/screens/favorites_screen.dart';
import 'package:A.N.R/app/modules/home/screens/home_screen.dart';
import 'package:A.N.R/app/modules/login/bindings/login_binding.dart';
import 'package:A.N.R/app/modules/login/screens/login_screen.dart';
import 'package:A.N.R/app/modules/reader/screens/reader_screen.dart';
import 'package:A.N.R/app/modules/search/bindings/search_binding.dart';
import 'package:A.N.R/app/modules/search/screens/search_screen.dart';
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
      curve: Curves.linear,
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.native,
      name: RoutesName.LOGIN,
      binding: LoginBinding(),
      page: () => const LoginScreen(),
    ),
    GetPage(
      curve: Curves.linear,
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.native,
      name: RoutesName.HOME,
      binding: HomeBinding(),
      page: () => HomeScreen(),
    ),
    GetPage(
      name: RoutesName.SEARCH,
      page: () => const SearchScreen(),
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.native,
      curve: Curves.linear,
      binding: SearchBinding(),
    ),
    GetPage(
      curve: Curves.linear,
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.native,
      name: RoutesName.BOOK,
      page: () => const BookScreen(),
    ),
    GetPage(
      curve: Curves.linear,
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.native,
      name: RoutesName.READER,
      page: () => const ReaderScreen(),
    ),
    GetPage(
      name: RoutesName.FAVORITES,
      curve: Curves.linear,
      transitionDuration: const Duration(milliseconds: 600),
      page: () => const FavoritesScreen(),
      binding: FavoritesBinding(),
      transition: Transition.native,
    ),
    GetPage(
      curve: Curves.linear,
      transitionDuration: const Duration(milliseconds: 600),
      transition: Transition.native,
      name: RoutesName.ABOUT,
      page: () => const AboutScreen(),
    ),
  ];
}
