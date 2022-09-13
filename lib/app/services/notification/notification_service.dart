import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:com_joaojsrbr_reader/app/core/utils/to_id.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/services/book_info.dart';

class NotificationsService extends GetxService {
  final AwesomeNotifications awesomeNotifications = AwesomeNotifications();

  Future<void> get dilog async {
    await Get.dialog(
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
      transitionCurve: Curves.easeInOutCubic,
    );
  }

  static DatabaseReference? get ref {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final favoritesRef =
        FirebaseDatabase.instance.ref('users/${user.uid}/favorites');

    favoritesRef.keepSynced(true);

    return favoritesRef;
  }

  static Future<void> checkChapter() async {
    if (ref == null) return;
    // int progress = 0;

    try {
      // isSucess = false;
      late num? totalChapters;
      late num? lastChapter;
      final DataSnapshot snapshot = await ref!.get();
      if (!snapshot.exists) return;

      for (DataSnapshot element in snapshot.children) {
        final item = element.value as Map<dynamic, dynamic>;
        final String name = item['name'];
        final String id = item['id'];
        Book? lastAdded = await bookInfo(item['url'], name);

        if (lastAdded == null) continue;
        if (!lastAdded.name.contains(name)) continue;

        // totalChapters = lastAdded.chapters.length;
        final DatabaseReference bookRef = ref!.child(id);
        if (item.containsKey('lastChapter')) {
          totalChapters = int.tryParse(lastAdded.totalChapters) ??
              double.tryParse(lastAdded.totalChapters);

          lastChapter = int.tryParse(item['lastChapter'] as String) ??
              double.tryParse(item['lastChapter'] as String);
        } else {
          await bookRef.set(
            BookItem(
              id: id,
              url: item['url'],
              imageURL: item['imageURL'],
              imageURL2: item['imageURL2'],
              name: lastAdded.name,
              tag: lastAdded.type ?? item['tag'],
              lastChapter: lastAdded.totalChapters,
            ).toMap,
          );
        }

        if (lastAdded.name == name) {
          if (item.containsKey('lastChapter')) {
            if (lastChapter == null || totalChapters == null) continue;
            if (lastChapter == totalChapters) {
              if (kDebugMode) {
                print(
                    'name: ${lastAdded.name} totalChapters: $totalChapters - lastChapter: $lastChapter');
              }
            } else if (totalChapters > lastChapter) {
              // final DatabaseReference bookRef =
              //     ref!.child(toId(lastAdded.name));

              if (kDebugMode) {
                print('$totalChapters > $lastChapter');
              }

              bookRef.set(
                BookItem(
                  id: id,
                  url: item['url'],
                  imageURL: item['imageURL'],
                  imageURL2: item['imageURL2'],
                  name: lastAdded.name,
                  tag: lastAdded.type ?? item['tag'],
                  lastChapter: totalChapters.toString(),
                ).toMap,
              );

              //! notificação
              final String imageURL = item['imageURL'];
              final String? imageURL2 = item['imageURL2'];
              final String? tag = lastAdded.type ?? item['tag'];
              late Map<String, String> payload;
              if (tag != null) {
                payload = <String, String>{
                  "id": toId(lastAdded.name),
                  "url": item['url'],
                  "imageURL": imageURL2 ?? imageURL,
                  "name": lastAdded.name,
                  "tag": tag,
                  "lastChapter": lastAdded.totalChapters,
                };
              } else {
                payload = <String, String>{
                  "id": toId(lastAdded.name),
                  "url": item['url'],
                  "imageURL": imageURL2 ?? imageURL,
                  "name": lastAdded.name,
                  "lastChapter": lastAdded.totalChapters,
                };
              }

              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: lastAdded.hashCode,
                  channelKey: 'manga_notifications',
                  payload: payload,
                  wakeUpScreen: true,
                  notificationLayout: NotificationLayout.BigPicture,
                  body: 'Capítulo Novo: ${lastAdded.totalChapters}',
                  bigPicture: item['imageURL2'] ?? item['imageURL'],
                  title: lastAdded.name,
                ),
              );
            }
          }
        }
      }
    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(stacktrace);
      }
      // isSucess = true;
    }
  }
}
