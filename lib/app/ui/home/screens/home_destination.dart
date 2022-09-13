import 'package:cached_network_image/cached_network_image.dart';
import 'package:com_joaojsrbr_reader/app/core/constants/app_theme.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/controlers/home_controller.dart';
import 'package:com_joaojsrbr_reader/app/ui/home/widgets/loading_more_sliver_list_book_element/loading_more_sliver_list_book_element.dart';
import 'package:filter_chips/filter_chips.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:com_joaojsrbr_reader/app/routes/routes.dart';
import 'package:com_joaojsrbr_reader/app/services/session.dart';

class HomeDestination extends StatefulWidget {
  const HomeDestination({super.key});

  @override
  State<HomeDestination> createState() => _HomeDestinationState();
}

class _HomeDestinationState extends State<HomeDestination>
    with AutomaticKeepAliveClientMixin<HomeDestination> {
  final User user = FirebaseAuth.instance.currentUser!;
  final controller = Get.find<HomeController>();

  Future<void> _userModal() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppThemeData.color(context).background,
        contentPadding: const EdgeInsets.all(2),
        titlePadding: const EdgeInsets.all(2),
        actionsPadding:
            const EdgeInsets.only(top: 6, bottom: 8, left: 30, right: 30),
        title: ListTile(
          title: Text(user.displayName ?? ''),
          subtitle: Text(user.email ?? ''),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoURL ?? ''),
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop('');
            },
            child: const Text('Ficar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop('logout');
            },
            child: const Text('Sair'),
          ),
        ],
        content: const Text(
          'Nós odiamos ver você partir...',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
      ),
    );

    if (result == 'logout') {
      await Session.signOut();
      if (mounted) Navigator.of(context).pushReplacementNamed(RoutesName.LOGIN);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: controller.onRefresh,
      child: CustomScrollView(
        cacheExtent: double.maxFinite,
        physics: const ClampingScrollPhysics(),
        controller: controller.scrollController,
        slivers: [
          SliverAppBar(
            floating: false,
            snap: false,
            stretch: false,
            title: const Text('HomePage'),
            leading: const SizedBox(
              height: 0,
              width: 0,
            ),
            leadingWidth: 0,
            expandedHeight: 110,
            actions: [
              IconButton(
                onPressed: _userModal,
                icon: const Icon(Icons.logout_rounded),
              ),
              IconButton(
                onPressed: () {
                  Get.toNamed(RoutesName.SEARCH);
                },
                icon: const Icon(Icons.search_rounded),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(top: 30),
                height: 100,
                child: FilterChipsWidget(
                  onChange: controller.onChange,
                  filters: controller.filters,
                ),
              ),
            ),
          ),
          LoadingMoreSliverListBookElement(
            sourceList: controller.result,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
