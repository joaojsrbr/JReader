import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/widgets/about_tile.dart';
import 'package:com_joaojsrbr_reader/app/widgets/sinopse.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Book;

    return Scaffold(
      appBar: AppBar(title: Text(args.name)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Sinopse(
              args.sinopse,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            AboutTileGenders(genders: args.categories),
            AboutTile(title: 'Nome', value: args.name),
            AboutTile(title: 'Tipo', value: args.type ?? 'Desconhecido'),
            AboutTile(title: 'Capítulos', value: args.totalChapters),
          ],
        ),
      ),
    );
  }
}
