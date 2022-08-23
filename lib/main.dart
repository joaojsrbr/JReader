import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';

import 'package:com_joaojsrbr_reader/app/core/constants/ports.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/file_mime_by_url.dart';
import 'package:com_joaojsrbr_reader/app/core/utils/folders.dart';
import 'package:com_joaojsrbr_reader/app/databases/downloads_db.dart';
import 'package:com_joaojsrbr_reader/app/models/download.dart';
import 'package:com_joaojsrbr_reader/app/my_app.dart';
import 'package:com_joaojsrbr_reader/app/services/book_content.dart';
import 'package:com_joaojsrbr_reader/app/services/notification/notifications_service.dart';
import 'package:com_joaojsrbr_reader/app/services/version/version_service.dart';
import 'package:com_joaojsrbr_reader/firebase_options.dart';

import 'firebase_options.dart';

SendPort? send() => IsolateNameServer.lookupPortByName(Ports.DOWNLOAD);

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
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

        send()?.send(DownloadSend(type: DownloadSendTypes.error, data: item));
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
  });
}

void main() async {
  // GestureBinding.instance.resamplingEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelGroupKey: 'manga_channel_group',
        channelKey: 'manga_notifications',
        channelName: 'MangaNew',
        enableVibration: true,
        importance: NotificationImportance.Default,
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
  );

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  await FirebaseAppCheck.instance.activate();
  initServices();

  runApp(
    const MyApp(),
  );
}

void initServices() async {
  Get.put(NotificationsService(), permanent: true);
  Get.put(VersionService(), permanent: true);
}
