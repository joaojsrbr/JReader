import 'package:com_joaojsrbr_reader/app/global_variable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

Future<void> startDownload() async {
  final PermissionStatus status = await Permission.storage.request();
  if (!status.isGranted && !status.isLimited) return;

  Workmanager().registerOneOffTask(
    GlobalVariable.downloadTaskKey,
    GlobalVariable.downloadTaskKey,
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    backoffPolicyDelay: const Duration(seconds: 8),
    backoffPolicy: BackoffPolicy.linear,
    initialDelay: Duration.zero,
  );
}
