import 'package:flutter/material.dart';

import '../../chat/pages/users_page.dart';

class UserViewWidget extends StatelessWidget {
  const UserViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 4,
        child: Navigator(
          onGenerateRoute: (RouteSettings settings) {
            // print('onGenerateRoute: ${settings}');
            // if (settings.name == '/' || settings.name == 'search') {
            if (settings.name == '/' || settings.name == 'convo') {
              return PageRouteBuilder(
                pageBuilder: (_, __, ___) => const UsersPage(),
              );
            } else {
              throw 'no page to show';
            }
          },
        ));
  }
}
