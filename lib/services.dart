import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/file_mime_by_url.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/folders.dart';
import 'package:com_joaojsrbr_reader/app/databases/downloads_db.dart';
import 'package:com_joaojsrbr_reader/app/global_variable.dart';
import 'package:com_joaojsrbr_reader/app/models/download.dart';
import 'package:com_joaojsrbr_reader/app/services/book_content.dart';
import 'package:com_joaojsrbr_reader/app/services/notification/notification_service.dart';
import 'package:com_joaojsrbr_reader/app/services/version/version_service.dart';
import 'package:com_joaojsrbr_reader/firebase_options.dart';
import 'package:com_joaojsrbr_reader/main.dart';
import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

Future<void> initServices() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Future.wait(
    [
      AwesomeNotifications().initialize(
        'resource://drawable/res_app_icon',
        [
          NotificationChannel(
            channelGroupKey: 'manga_channel_group',
            channelKey: 'manga_notifications',
            channelName: 'MangaNew',
            defaultColor: const Color.fromARGB(255, 22, 23, 40),
            enableVibration: true,
            importance: NotificationImportance.High,
            playSound: true,
            channelDescription: 'notificação de manga novo',
          )
        ],
        channelGroups: [
          NotificationChannelGroup(
            channelGroupkey: 'manga_channel_group',
            channelGroupName: 'Grupo de notificação',
          )
        ],
        debug: true,
      ),
      Workmanager().initialize(callbackDispatcher, isInDebugMode: false),
      FirebaseAppCheck.instance.activate(),
    ],
  );
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  Get.put<NotificationsService>(NotificationsService(), permanent: true);
  Get.put<VersionService>(VersionService(), permanent: true);
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case GlobalVariable.downloadTaskKey:
        final DownloadsDB db = DownloadsDB.db;
        List<Download> items = await db.notFinished;

        if (items.isEmpty) return Future.value(true);

        for (Download item in items) {
          final String bookPath = await Folders.createBook(item.bookId);

          List<String> content = item.content;

          if (content.isEmpty) {
            content = await bookContent(item.contentUrl);

            final Download updatedItem = Download(
              bookId: item.bookId,
              chapterId: item.chapterId,
              content: content,
              contentUrl: item.contentUrl,
              status: item.status,
            );

            await db.update(updatedItem);
            send()?.send(DownloadSend(
              type: DownloadSendTypes.updated,
              data: updatedItem,
            ));
          }

          final String path = await Folders.createChapter(
            bookPath: bookPath,
            chapterId: item.chapterId,
          );

          int index = 1;
          bool error = false;
          for (String url in content) {
            final String type = fileMimeByUrl(url);
            final String savePath = Directory('$path/$index.$type').path;

            try {
              await Dio().download(url, savePath);
              index++;
            } catch (_) {
              error = true;
              break;
            }
          }

          if (error) {
            await db.remove(item.id);
            await Folders.deleteChapter(
              bookPath: bookPath,
              chapterId: item.chapterId,
            );

            send()
                ?.send(DownloadSend(type: DownloadSendTypes.error, data: item));
          } else {
            final Download downloaded = Download(
              bookId: item.bookId,
              chapterId: item.chapterId,
              content: content,
              contentUrl: item.contentUrl,
              status: DownloadStatus.finished,
            );

            await db.update(downloaded);
            send()?.send(DownloadSend(
              type: DownloadSendTypes.finished,
              data: downloaded,
            ));
          }
        }

        items = await db.notFinished;
        if (items.isEmpty) return Future.value(true);
        return Future.value(false);
      case GlobalVariable.mangaNotificationKey:
        await Firebase.initializeApp();
        FirebaseDatabase.instance.setPersistenceEnabled(true);
        await FirebaseAppCheck.instance.activate();
        await NotificationsService.checkChapter();
        return Future.value(true);
    }
    return Future.value(true);
  });
}
