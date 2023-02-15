import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_bar.dart';
import '../common.dart';
import '../drawer.dart';

class MessageDetailsPage extends ConsumerWidget {
  static const routeName = '/message';

  final String messageId;

  MessageDetailsPage(this.messageId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: //AdminAppBar.getBar(context, ref),
            AppBar(
          title: Text('Message ${messageId}'),
          actions: [ThemeIconButton()],
        ),
        drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
            ? TheDrawer.buildDrawer(context)
            : null,
        body: Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(child: Text(messageId))
                // Expanded(child: UserList()),
                // Expanded(child: UserDetails(ref.watch(activeUser)))
              ],
            )),
      );
}
