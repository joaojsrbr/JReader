import 'dart:convert';

import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
// ignore: depend_on_referenced_packages
import 'package:pub_semver/pub_semver.dart';

import 'package:com_joaojsrbr_reader/app/core/constants/string.dart';

class VersionService extends GetxService {
  PackageInfo? packageInfo;

  @override
  void onReady() async {
    packageInfo = await PackageInfo.fromPlatform();
    super.onReady();
  }

  Future<Version?> checkUpdate() async {
    http.Response responce =
        await http.get(Uri.parse(jreaderLatestReleaseApiUrl));
    if (responce.statusCode >= 200 && responce.statusCode <= 299) {
      String? tag = (jsonDecode(responce.body)["tag_name"]);
      Version? latestReleaseBuildNumber =
          tag != null ? Version.parse(tag.replaceAll(r'v', '')) : null;
      Version? packageBuildNumber =
          packageInfo != null ? Version.parse(packageInfo!.version) : null;
      if (latestReleaseBuildNumber != null && packageBuildNumber != null) {
        if (packageBuildNumber.compareTo(latestReleaseBuildNumber) < 0) {
          return latestReleaseBuildNumber;
        }
      }
    }
    return null;
  }
}
