import 'package:com_joaojsrbr_reader/app/core/constants/app_theme.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/widgets/sinopse.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static void showBottomSheet(BuildContext context, Book data) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final book = data;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppThemeData.color(context).background,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          child: AboutScreen(
            book: book,
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }

  const AboutScreen({
    Key? key,
    required this.book,
    required this.scrollController,
  }) : super(key: key);
  final Book book;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              "Sinopse",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Sinopse(
            book.sinopse,
            margin: const EdgeInsets.only(
              bottom: 8,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
          ),
          // AboutTileGenders(
          //   genders: book.categories,
          // ),
          // AboutTile(
          //   title: 'Nome',
          //   value: book.name,
          // ),
          // AboutTile(
          //   title: 'Tipo',
          //   value: book.type ?? 'Desconhecido',
          // ),
          // AboutTile(
          //   title: 'Capítulos',
          //   value: book.totalChapters,
          // ),
        ],
      ),
    );
  }
}
