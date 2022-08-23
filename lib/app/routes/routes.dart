// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:com_joaojsrbr_reader/app/ui/about/screens/about_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/book/bindings/book_screen_binding.dart';
import 'package:com_joaojsrbr_reader/app/ui/book/screens/book_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/favorites/screens/favorites_destination.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/bindings/home_binding.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/screens/home_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/login/bindings/login_binding.dart';
import 'package:com_joaojsrbr_reader/app/ui/login/screens/login_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/reader/bindings/reader_binding.dart';
import 'package:com_joaojsrbr_reader/app/ui/reader/screens/reader_screen.dart';
import 'package:com_joaojsrbr_reader/app/ui/search/bindings/search_binding.dart';
import 'package:com_joaojsrbr_reader/app/ui/search/screens/search_screen.dart';

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
      binding: BookScreenBinding(),
      page: () => const BookScreen(),
    ),
    GetPage(
      curve: Curves.linear,
      name: RoutesName.READER,
      // page: () => const ReaderScreen2(),
      page: () => const ReaderScreen(),
      binding: ReaderBinding(),
    ),
    GetPage(
      name: RoutesName.FAVORITES,
      curve: Curves.linear,
      page: () => const FavoritesDestination(),
    ),
    GetPage(
      curve: Curves.linear,
      name: RoutesName.ABOUT,
      page: () => const AboutScreen(),
    ),
  ];
}
