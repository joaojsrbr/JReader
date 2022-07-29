import 'package:webview_flutter/webview_flutter.dart';

class ReaderJS {
  final WebViewController controller;

  const ReaderJS(this.controller);

  Future<void> scrollTo(double position) async {
    await controller.runJavascript(
        '''window.scrollTo({
      top: $position,
      left: 0,
      behavior: 'auto',
    });''');
  }

  Future<void> removeLoading() async {
    controller.runJavascript("document.querySelector('#loading').remove();");
  }

  Future<void> finishedChapters() async {
    await controller.runJavascript("insertFinish();");
  }

  Future<void> insertContent(
    List<String> sources,
    int index,
    String name,
  ) async {
    final String images = sources.join(',,separator,,');
    await controller
        .runJavascript("insertContent('$images', $index, '$name');");
  }
}
