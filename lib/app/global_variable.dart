import 'package:flutter/material.dart';

/// Global variables
class GlobalVariable {
  /// This global key is used in material app for navigation through firebase notifications.
  /// [navState] usage can be found in [notification_service.dart] file.
  static final GlobalKey<NavigatorState> navState =
      GlobalKey<NavigatorState>(debugLabel: "Main Navigator");

  static GlobalKey mtAppKey = GlobalKey(debugLabel: "Main GetMaterialApp");

  static const downloadTaskKey = "br.joaojsrbr.workmanager.download";
  static const mangaNotificationKey =
      "br.joaojsrbr.workmanager.mangaNotification";
}
