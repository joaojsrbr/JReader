// ignore_for_file: prefer_final_fields

import 'dart:ui';

import 'package:com_joaojsrbr_reader/app/ui/book/controlers/book_screen_controller.dart';
import 'package:com_joaojsrbr_reader/app/ui/book/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:com_joaojsrbr_reader/app/core/constants/ports.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/book_info.dart';
import 'package:com_joaojsrbr_reader/app/services/favorites.dart';
import 'package:com_joaojsrbr_reader/app/stores/favorites_store.dart';
import 'package:com_joaojsrbr_reader/app/stores/historic_store.dart';

class BookScreen extends GetView<BookScreenController> {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HistoricStore store = Provider.of<HistoricStore>(context);

    return GetBuilder<BookScreenController>(
      autoRemove: false,
      didChangeDependencies: (state) {
        final FavoritesStore store = Provider.of<FavoritesStore>(context);
        // state.controller?.bookItem =
        //     ModalRoute.of(context)!.settings.arguments as BookItem;
        state.controller?.setbookItem =
            ModalRoute.of(context)!.settings.arguments as BookItem;

        state.controller?.setfavorites = Favorites(
            book: state.controller!.bookItem, store: store, context: context);

        IsolateNameServer.registerPortWithName(
            state.controller!.port.sendPort, Ports.DOWNLOAD);
        state.controller?.port.listen(state.controller?.sendListening);
        state.controller?.getDownloadItem();

        bookInfo(
                state.controller!.bookItem.url, state.controller!.bookItem.name)
            .then(
          (value) {
            if (!state.mounted) return;
            state.controller?.setbook = value;
            state.controller?.setchapters = value?.chapters ?? [];
            state.controller?.setisLoading = false;
          },
        ).catchError(
          (e) {
            if (!state.mounted) return;
            final ScaffoldMessengerState messenger =
                ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  'Algo deu errado ao obter as informações do ${state.controller?.bookItem.tag ?? 'livro'}.',
                ),
              ),
            );
          },
        );
      },
      builder: (controller) => Screen(
        store: store,
      ),
    );
  }
}
