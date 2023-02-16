import 'package:flutter/material.dart';
import 'package:gptmoe/messages/user_messages_page.dart';

class TheDrawer {
  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text('Menu'),
          ),
          ListTile(
              leading: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              title: const Text('Search'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return UserMessagesPage();
                  },
                ));
              }),
          ListTile(
              leading: IconButton(
                icon: const Icon(Icons.view_list),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              title: const Text('Lists'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    //return ResumesPage();
                    return const Text('hi');
                    // return ListsPage();
                  },
                ));
              }),
        ],
      ),
    );
  }
}
