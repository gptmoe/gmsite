import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../resources/constants/chat_gpt_user.dart';
import '../providers/home_page_provider.dart';
import '../widgets/not_authenticated_section.dart';
import '../../chat/pages/chat_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).value;

    if (user == null) {
      return const NotAuthenticatedSection();
    }

    ref.listen<bool>(isHaveRoomProvider, (_, isHaveRoom) async {
      if (!isHaveRoom) {
        final navigator = Navigator.of(context);

        // TODO(zharfan104): Make to be not always create user everytime listening this
        await FirebaseChatCore.instance.createUserInFirestore(chatGptUser);

        final room = await FirebaseChatCore.instance.createRoom(chatGptUser);

        await navigator.push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              room: room,
            ),
          ),
        );

        return;
      }

      final rooms = ref.read(roomsProvider);
      final room = rooms.value!.first;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatPage(
            room: room,
          ),
        ),
      );
    });

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
