import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptmoe/core/utils/common.dart';
import 'package:gptmoe/features/admin/pages/user_details.dart';
import 'package:gptmoe/resources/widgets/drawer.dart';

import '../widgets/admin_app_bar.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AdminAppBar.getBar(context, ref),
          drawer: (MediaQuery.of(context).size.width < kWideScreenWidth)
              ? TheDrawer.buildDrawer(context)
              : null,
          body: Container(
              margin: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Expanded(child: UserList()),
                  Expanded(child: UserDetails(ref.watch(activeUser)))
                ],
              )),
        ));
  }
}
