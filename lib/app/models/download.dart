import 'package:A.N.R/app/core/utils/to_id.dart';

class Download {
  final String bookId;
  final String chapterId;
  final List<String> content;
  final String contentUrl;
  final DownloadStatus status;

  const Download({
    required this.bookId,
    required this.chapterId,
    required this.content,
    required this.contentUrl,
    required this.status,
  });

  String get id => toId('$bookId/$chapterId');

  bool get finished => status == DownloadStatus.finished;

  Map<String, dynamic> get toMap {
    return {
      'bookId': bookId,
      'chapterId': chapterId,
      'content': content.join(',,separator,,'),
      'contentUrl': contentUrl,
      'status': status.value,
    };
  }

  static List<String> contentList(String content) {
    final List<String> listContent = content.split(',,separator,,');

    listContent.removeWhere((element) => element == '');
    return listContent;
  }
}

class DownloadSend {
  final DownloadSendTypes type;
  final Download data;

  const DownloadSend({required this.type, required this.data});
}

enum DownloadStatus { finished, downloading }

extension DownloadStatusExtension on DownloadStatus {
  String get value {
    switch (this) {
      case DownloadStatus.finished:
        return 'finished';

      case DownloadStatus.downloading:
        return 'downloading';
    }
  }
}

enum DownloadSendTypes { error, finished, updated }

extension DownloadSendTypesExtension on DownloadSendTypes {
  String get value {
    switch (this) {
      case DownloadSendTypes.error:
        return 'error';

      case DownloadSendTypes.finished:
        return 'finished';

      case DownloadSendTypes.updated:
        return 'updated';
    }
  }
}
