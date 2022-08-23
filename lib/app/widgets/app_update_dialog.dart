// ignore_for_file: depend_on_referenced_packages

import 'package:com_joaojsrbr_reader/app/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> appUpdateDialog(Version newRelease) {
  return Get.defaultDialog(
    backgroundColor: Get.theme.colorScheme.background,
    title: 'Nova atualização disponível',
    content: Text(
      'Versão ${newRelease.canonicalizedVersion} disponível!!',
    ),
    confirm: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: () async {
        if (!await launchUrl(
          Uri.parse(Strings.jreaderLatestReleaseUrl),
          mode: LaunchMode.externalApplication,
        )) {
          Clipboard.setData(
            const ClipboardData(
              text: Strings.jreaderLatestReleaseUrl,
            ),
          );
          Get.rawSnackbar(
              title: 'Copying GitHub to clipboard',
              message: 'Failed to launch ${Strings.jreaderLatestReleaseUrl}');
        }
        Get.back();
      },
      icon: const Icon(Icons.open_in_new),
      label: const Text(
        'GitHub',
      ),
    ),
    // textCancel: 'Close',
    cancel: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      onPressed: () async {
        Get.back();
      },
      icon: const Icon(Icons.close),
      label: const Text(
        'Close',
      ),
    ),
    onCancel: () {},
  );
}
