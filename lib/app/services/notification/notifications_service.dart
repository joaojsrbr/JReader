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
  void _setupNotificaitons2() async {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        // if (kDebugMode) {
        //   print(isAllowed);
        // }
        if (!isAllowed) {
          Get.dialog(
            AlertDialog(
              backgroundColor: Get.theme.colorScheme.background,
              title: const Text('Permitir notificações'),
              content: const Text(
                  'Nosso aplicativo gostaria de enviar notificações.'),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  autofocus: true,
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then(
                        (_) => Get.back(),
                      ),
                  child: const Text(
                    'Permitir',
                    style: TextStyle(
                      // color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Get.back();
                  },
                  child: const Text(
                    'Mais tarde',
                    style: TextStyle(
                      // color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          );
          // showDialog(
          //   context: scaffoldKey.currentState!.context,
          //   builder: (context) => AlertDialog(
          //     // backgroundColor: const Color(0xfffbfbfb),
          //     backgroundColor: Get.theme.colorScheme.background,
          //     title: const Text(
          //       'Get Notified!',
          //       maxLines: 2,
          //       textAlign: TextAlign.center,
          //       style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
          //     ),
          //     content: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Image.asset(
          //           'assets/images/animated-bell.gif',
          //           height: MediaQuery.of(context).size.height * 0.3,
          //           fit: BoxFit.fitWidth,
          //         ),
          //         const Text(
          //           'Allow Awesome Notifications to send you beautiful notifications!',
          //           maxLines: 4,
          //           textAlign: TextAlign.center,
          //         ),
          //       ],
          //     ),
          //     actions: [
          //       TextButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           child: const Text(
          //             'Later',
          //             style: TextStyle(color: Colors.grey, fontSize: 18),
          //           )),
          //       TextButton(
          //         onPressed: () async {
          //           isAllowed = await AwesomeNotifications()
          //               .requestPermissionToSendNotifications();
          //           Navigator.pop(context);
          //         },
          //         child: const Text(
          //           'Allow',
          //           style: TextStyle(
          //               color: Colors.deepPurple,
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //     ],
          //   ),
          // );

          // AwesomeNotifications().requestPermissionToSendNotifications();
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
  @override
  void onReady() async {
    _setupNotificaitons2();
    Timer.periodic(
      const Duration(minutes: 5),
      (timer) async {
        if (isSucess) {
          await neoxCheckChapter();
        }
      },
    );

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

  Future<void> neoxCheckChapter() async {
    if (ref == null) return;
    isSucess = false;

    try {
      final DataSnapshot snapshot = await ref!.get();
      if (!snapshot.exists) return;

      for (DataSnapshot element in snapshot.children) {
        final item = element.value as Map<dynamic, dynamic>;
        Book? lastAdded = await bookInfo(item['url'], item['name']);
        if (lastAdded == null) continue;

        if (lastAdded.name == item['name']) {
          if (item.containsKey('lastChapter')) {
            if (item['lastChapter'] == lastAdded.totalChapters) {
              if (kDebugMode) {
                print(
                    'igual - name: ${lastAdded.name} - ${lastAdded.totalChapters} - ${item['lastChapter']} - ${item['url']}');
              }

              // isSucess = true;
            } else if (int.parse(lastAdded.totalChapters) >
                int.parse(item['lastChapter'])) {
              // isSucess = true;
              final DatabaseReference bookRef =
                  ref!.child(toId(lastAdded.name));

              if (kDebugMode) {
                print('${lastAdded.totalChapters} > ${item['lastChapter']}');
              }
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

              AwesomeNotifications().createNotification(
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
          }
        }
      }
      isSucess = true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
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
