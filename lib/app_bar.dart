import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptmoe/main.dart';
import 'package:gptmoe/state/theme_state_notifier.dart';
import 'package:gptmoe/common.dart';

class MyAppBar {
  static final List<String> _tabs = [
    'convo',
  ];

  static PreferredSizeWidget getBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading:
          (MediaQuery.of(context).size.width < kWideScreenWidth) ? true : false,
      leadingWidth:
          (MediaQuery.of(context).size.width < kWideScreenWidth) ? null : 100,
      leading: (MediaQuery.of(context).size.width < kWideScreenWidth)
          ? null
          : const Padding(
              padding: EdgeInsets.all(10),
              child: Text(''),
            ),
      title: (MediaQuery.of(context).size.width < kWideScreenWidth)
          ? null
          : Align(
              child: SizedBox(
                  width: 800,
                  child: TabBar(
                    tabs: _tabs
                        .map((t) => Tab(
                            iconMargin: const EdgeInsets.all(0),
                            child:
                                // GestureDetector(
                                //     behavior: HitTestBehavior.translucent,
                                //onTap: () => navigatePage(text, context),
                                //child:
                                Text(t.toUpperCase(),
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: const TextStyle(
                                        color:
                                            // Theme.of(context).brightness == Brightness.light
                                            //     ? Color(DARK_GREY)
                                            //:
                                            Colors.white))))
                        .toList(),
                    onTap: (index) {
                      Navigator.of(context).pushNamed(_tabs[index]);
                    },
                  ))),
      actions: [
        const ThemeIconButton(),
        IconButton(
            onPressed: () {
              ref.read(isLoggedIn.notifier).value = false;
              FirebaseAuth.instance.signOut();
              // print("Signed out");
            },
            icon: const Icon(Icons.exit_to_app))
      ],
    );
  }
}

class ThemeIconButton extends ConsumerWidget {
  const ThemeIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkState = ref.watch(themeStateNotifierProvider);
    return IconButton(
        tooltip: 'dark/light mode',
        onPressed: () {
          ref.read(themeStateNotifierProvider.notifier).changeTheme();
        },
        icon: Icon(isDarkState == true
            ? Icons.nightlight
            : Icons.nightlight_outlined));
  }
}
