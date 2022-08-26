// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/to_id.dart';
import 'package:com_joaojsrbr_reader/app/models/book.dart';
import 'package:com_joaojsrbr_reader/app/models/book_item.dart';
import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/book_info.dart';
import 'package:com_joaojsrbr_reader/app/services/notification/widgets/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsService extends GetxService {
  late AwesomeNotifications awesomeNotifications;

  @override
  void onInit() {
    awesomeNotifications = AwesomeNotifications();

    super.onInit();
  }

  @override
  void onReady() async {
    _setupNotificaitons2();
    if (isSucess) {
      Timer.periodic(
        const Duration(minutes: 10),
        (timer) async {
          await awesomeNotifications.isNotificationAllowed().then(
            (value) async {
              if (value) {
                await checkChapter(false);
              }
            },
          );
        },
      );
    }
    // await checkChapter(false);
    super.onReady();
  }

  void _setupNotificaitons2() async {
    await awesomeNotifications.isNotificationAllowed().then(
      (isAllowed) {
        if (kDebugMode) {
          print(isAllowed);
        }
        if (!isAllowed) {
          Get.dialog(
            Dilog(
              awesomeNotifications: awesomeNotifications,
            ),
          );
        }
      },
    );
    awesomeNotifications.actionStream.listen(
      (ReceivedNotification receivedNotification) {
        final String? channelKey = receivedNotification.channelKey;
        if (channelKey == null) return;

        if (kDebugMode) {
          print(receivedNotification.payload);
          print(channelKey);
        }

        if (channelKey.contains('manga_notifications')) {
          Get.toNamed(
            RoutesName.BOOK,
            // id: receivedNotification.id,
            arguments: BookItem(
              id: receivedNotification.payload!['id']!,
              url: receivedNotification.payload!['url']!,
              imageURL: receivedNotification.payload!['imageURL']!,
              name: receivedNotification.payload!['name']!,
              tag: receivedNotification.payload!['tag'],
              lastChapter: receivedNotification.payload!['lastChapter'],
              headers: headers(receivedNotification.payload!['url']!),
            ),
          );
        }
      },
    );
  }

  bool isSucess = true;

  Future<void> _snackBar(Book lastAdded) async {
    Get.snackbar(
      lastAdded.name,
      'Capítulo Novo: ${lastAdded.totalChapters}',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.theme.colorScheme.background,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  Future<void> createNotification(
      Book lastAdded, Map<dynamic, dynamic> item) async {
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

    await awesomeNotifications.createNotification(
      content: NotificationContent(
        // id: int.parse(lastAdded.totalChapters),
        // id: lastAdded.hashCode,
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

  Future<void> checkChapter(bool snack) async {
    if (ref == null) return;
    // int progress = 0;

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
        if (!lastAdded.name.contains(name)) continue;

        // totalChapters = lastAdded.chapters.length;
        if (item.containsKey('lastChapter')) {
          totalChapters = int.tryParse(lastAdded.totalChapters) ??
              double.tryParse(lastAdded.totalChapters);

          lastChapter = int.tryParse(item['lastChapter'] as String) ??
              double.tryParse(item['lastChapter'] as String);
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
              lastChapter: lastAdded.totalChapters,
            ).toMap,
          );
        }

        if (lastAdded.name.contains(name)) {
          if (item.containsKey('lastChapter')) {
            if (lastChapter == null || totalChapters == null) continue;
            if (lastChapter == totalChapters) {
              if (kDebugMode) {
                print(
                    'name: ${lastAdded.name} totalChapters: $totalChapters - lastChapter: $lastChapter');
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
              switch (snack) {
                case false:
                  await createNotification(lastAdded, item);
                  break;
                case true:
                  await _snackBar(lastAdded);
                  break;
              }
            }
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

// extension BoolParsing on String {
//   bool parseBool() {
//     if (toLowerCase() == 'true') {
//       return true;
//     } else if (toLowerCase() == 'false') {
//       return false;
//     }

//     throw '"$this" can not be parsed to boolean.';
//   }
// }
