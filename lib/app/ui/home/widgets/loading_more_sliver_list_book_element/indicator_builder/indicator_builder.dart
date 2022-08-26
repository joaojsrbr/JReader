import 'package:com_joaojsrbr_reader/app/ui/home/controlers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

Widget indicatorBuilder(
  BuildContext context,
  IndicatorStatus status,
) {
  final load = Get.find<HomeController>().inrefresh;
  Widget _setbackground(
      bool full, Widget widget, double height, BuildContext context) {
    widget = Container(
      width: double.infinity,
      height: 200,
      color: Theme.of(context).colorScheme.background,
      alignment: Alignment.center,
      child: widget,
    );
    return widget;
  }

  Widget getIndicator(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.platform == TargetPlatform.iOS
        ? const CupertinoActivityIndicator(
            animating: true,
            radius: 16.0,
          )
        : const CircularProgressIndicator(
            strokeWidth: 2.0,
          );
  }

  bool isSliver = true;
  late Widget widget;
  switch (status) {
    case IndicatorStatus.none:
      widget = Container(height: 0.0);
      if (isSliver) {
        widget = SliverFillRemaining(
          child: widget,
        );
      }
      break;
    case IndicatorStatus.loadingMoreBusying:
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 0.0),
            height: 30.0,
            width: 30.0,
            child: getIndicator(context),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Carregando..."),
          ),
        ],
      );
      widget = Container();
      widget = _setbackground(false, widget, 50.0, context);
      // if (isSliver) {
      //   widget = SliverToBoxAdapter(
      //     child: widget,
      //   );
      // }
      break;
    case IndicatorStatus.fullScreenBusying:
      widget = ValueListenableBuilder<bool>(
        valueListenable: load,
        builder: (context, value, widget) => value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getIndicator(context),
                ],
              )
            : Container(),
      );
      widget = _setbackground(false, widget, 35.0, context);
      if (isSliver) {
        widget = SliverFillRemaining(
          child: widget,
        );
      }
      break;
    case IndicatorStatus.error:
      widget = const Center(
        child: Icon(
          Icons.error,
        ),
      );
      widget = _setbackground(false, widget, 35.0, context);
      widget = GestureDetector(
        onTap: () {
          // repository.errorRefresh();
        },
        child: widget,
      );
      if (isSliver) {
        widget = SliverFillRemaining(
          child: widget,
        );
      }
      break;
    case IndicatorStatus.fullScreenError:
      widget = const Center(
        child: Icon(
          Icons.error,
        ),
      );
      widget = _setbackground(true, widget, double.infinity, context);
      widget = GestureDetector(
        onTap: () {
          // repository.errorRefresh();
        },
        child: widget,
      );
      if (isSliver) {
        widget = SliverFillRemaining(
          child: widget,
        );
      }
      break;
    case IndicatorStatus.noMoreLoad:
      // if (isSliver) {
      //   widget = SliverFillRemaining(
      //     child: Container(),
      //   );
      // }
      widget = Container();
      // widget = Padding(
      //     padding: const EdgeInsets.only(top: 2.0),
      //     child: _setbackground(false, widget, 35.0, context));
      // if (isSliver) {
      //   widget = SliverFillRemaining(
      //     child: widget,
      //   );
      // }
      break;
    case IndicatorStatus.empty:
      widget = Container(
        margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 180.0,
                width: 180.0,
                child: Image.asset(
                  //https://flutter.io/docs/development/ui/assets-and-images
                  'assets/empty.jpeg',
                  // color: Theme.of(context).colorScheme.background,
                  // theme.brightness == Brightness.dark
                  //     ? 'assets/empty_dark.png'
                  //     : 'assets/empty_light.png',
                  package: 'loading_more_list',
                ),
              ),
            ],
          ),
        ),
      );
      // widget = _setbackground(true, widget, double.infinity, context);
      if (isSliver) {
        widget = SliverFillRemaining(
          child: widget,
        );
      }
      break;
  }
  return widget;
}
