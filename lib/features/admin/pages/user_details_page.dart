import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptmoe/core/utils/common.dart';
import 'package:gptmoe/features/admin/pages/user_details.dart';
import 'package:gptmoe/resources/widgets/drawer.dart';

import '../widgets/admin_app_bar.dart';

class UserDetailsPage extends ConsumerWidget {
  static const routeName = '/client';

  final String uid;

  const UserDetailsPage(this.uid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('building userDetails');
    // print(ModalRoute.of(context)!.settings);
    // final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: //AdminAppBar.getBar(context, ref),
          AppBar(
        title: Text('User Details for $uid'),
        actions: const [ThemeIconButton(), SignOutButton()],
      ),
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
              Expanded(child: UserDetails(uid))
              // Expanded(child: UserList()),
              // Expanded(child: UserDetails(ref.watch(activeUser)))
            ],
          )),
    );
  }
}
