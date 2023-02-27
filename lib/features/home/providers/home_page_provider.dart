import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/state/generic_state_notifier.dart';

final userProvider = StreamProvider<User?>((ref) {
  final auth = FirebaseAuth.instance;
  return auth.authStateChanges();
});

final roomsProvider = FutureProvider<List<types.Room>>((ref) {
  return FirebaseChatCore.instance.rooms().first;
});

final isHaveRoomProvider = StateNotifierProvider<GenericStateNotifier<bool>, bool>((ref) {
  final isLoggedIn = ref.watch(isLoggedInProvider);
  if (isLoggedIn) {
    final watchRooms = ref.watch(roomsProvider);
    final rooms = watchRooms.asData?.value;
    final isRoomExists = rooms != null && rooms.isNotEmpty;

    return GenericStateNotifier<bool>(isRoomExists);
  }

  return GenericStateNotifier<bool>(false);
});

final authenticationStateProvider = Provider((ref) {
  final user = ref.watch(userProvider).value;
  return user != null;
});

final isLoggedInProvider = StateNotifierProvider<GenericStateNotifier<bool>, bool>(
  (ref) => GenericStateNotifier<bool>(ref.watch(authenticationStateProvider)),
);
