// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/to_id.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/book_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsService extends GetxService {
  // @override
  // void onInit() async {
  //   await checkChapter();
  //   super.onInit();
  // }

  void _setupNotificaitons2() async {
    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        // if (kDebugMode) {
        //   print(isAllowed);
        // }
        if (!isAllowed) {
          Get.dialog(
            AlertDialog(
              backgroundColor: Get.theme.colorScheme.background,
              title: const Text(
                'Nosso aplicativo gostaria de enviar notificações',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/animated-bell.gif',
                    colorBlendMode: BlendMode.color,
                    color: Colors.transparent,
                    fit: BoxFit.fitWidth,
                    height: Get.height * 0.3,
                  )
                ],
              ),
              // actionsPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    'Negar',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then(
                        (_) => Get.back(),
                      ),
                  child: const Text(
                    'Permitir',
                    style: TextStyle(
                      // color: Colors.teal,
                      color: Colors.deepPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      if (kDebugMode) {
        print(receivedNotification.payload);
      }
      Get.toNamed(
        RoutesName.BOOK,
        // id: receivedNotification.id,
        arguments: BookItem(
          id: receivedNotification.payload!['id']!,
          url: receivedNotification.payload!['url']!,
          imageURL: receivedNotification.payload!['imageURL']!,
          imageURL2: receivedNotification.payload!['imageURL2'],
          name: receivedNotification.payload!['name']!,
          tag: receivedNotification.payload!['tag'],
          lastChapter: receivedNotification.payload!['lastChapter'],
          headers: headers(receivedNotification.payload!['url']!),
        ),
      );
      // Navigator.of(context).pushNamed(
      //     '/NotificationPage',
      //     arguments: {
      //         // your page params. I recommend you to pass the
      //         // entire *receivedNotification* object
      //         id: receivedNotification.id
      //     }
      // );
    });
  }

  bool isSucess = true;

  void createNotification(Book lastAdded, Map<dynamic, dynamic> item) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        // id: int.parse(lastAdded.totalChapters),
        id: lastAdded.hashCode,

        notificationLayout: NotificationLayout.BigPicture,
        channelKey: 'manga_notifications',
        payload: {
          "id": toId(lastAdded.name),
          "url": item['url'],
          "imageURL": item['imageURL'],
          "imageURL2": item['imageURL2'],
          "name": lastAdded.name,
          "tag": lastAdded.type ?? item['tag'],
          "lastChapter": lastAdded.totalChapters,
        },

        wakeUpScreen: true,
        body: 'Capítulo Novo: ${lastAdded.totalChapters}',
        bigPicture: item['imageURL2'] ?? item['imageURL'],
        title: lastAdded.name,
      ),
    );
  }

  @override
  void onReady() async {
    _setupNotificaitons2();
    if (isSucess) {
      Timer.periodic(
        const Duration(minutes: 5),
        (timer) async {
          await AwesomeNotifications().isNotificationAllowed().then(
            (value) async {
              if (value) {
                await checkChapter();
              }
            },
          );
        },
      );
    }

    super.onReady();
  }

  static Map<String, String> headers(String url) {
    String baseURL = url;

    return {
      'Origin': baseURL,
      'Referer': '$baseURL/',
      'accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'upgrade-insecure-requests': '1',
      'user-agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36',
    };
  }

  static DatabaseReference? get ref {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final favoritesRef =
        FirebaseDatabase.instance.ref('users/${user.uid}/favorites');

    favoritesRef.keepSynced(true);

    return favoritesRef;
  }

  Future<void> checkChapter() async {
    if (ref == null) return;

    try {
      isSucess = false;
      late num? totalChapters;
      late num? lastChapter;
      final DataSnapshot snapshot = await ref!.get();
      if (!snapshot.exists) return;

      for (DataSnapshot element in snapshot.children) {
        final item = element.value as Map<dynamic, dynamic>;
        final String name = item['name'];
        Book? lastAdded = await bookInfo(item['url'], name);
        if (lastAdded == null) continue;

        // totalChapters = lastAdded.chapters.length;
        totalChapters = int.tryParse(lastAdded.totalChapters) ??
            double.tryParse(lastAdded.totalChapters);

        lastChapter = int.tryParse(item['lastChapter']) ??
            double.tryParse(item['lastChapter']);

        if (lastChapter == null || totalChapters == null) continue;

        if (lastAdded.name == name) {
          if (item.containsKey('lastChapter')) {
            if (lastChapter == totalChapters) {
              if (kDebugMode) {
                print(
                    'name: ${lastAdded.name} totalChapters: $totalChapters - lastChapter: $lastChapter');
                // print(
                //     'igual - name: ${lastAdded.name} - $totalChapters - $lastChapter - ${item['url']}');
              }
            } else if (totalChapters > lastChapter) {
              final DatabaseReference bookRef =
                  ref!.child(toId(lastAdded.name));

              if (kDebugMode) {
                print('$totalChapters > $lastChapter');
              }
              bookRef.set(
                BookItem(
                  id: toId(lastAdded.name),
                  url: item['url'],
                  imageURL: item['imageURL'],
                  imageURL2: item['imageURL2'],
                  name: lastAdded.name,
                  tag: lastAdded.type ?? item['tag'],
                  lastChapter: '$totalChapters',
                ).toMap,
              );
              createNotification(lastAdded, item);
            }
          } else {
            final DatabaseReference bookRef = ref!.child(toId(lastAdded.name));
            bookRef.set(
              BookItem(
                id: toId(lastAdded.name),
                url: item['url'],
                imageURL: item['imageURL'],
                imageURL2: item['imageURL2'],
                name: lastAdded.name,
                tag: lastAdded.type ?? item['tag'],
                lastChapter: '$totalChapters',
              ).toMap,
            );
          }
        }
      }
      isSucess = true;
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(stacktrace);
      }
    }
  }
}

extension BoolParsing on String {
  bool parseBool() {
    if (toLowerCase() == 'true') {
      return true;
    } else if (toLowerCase() == 'false') {
      return false;
    }

    throw '"$this" can not be parsed to boolean.';
  }
}
