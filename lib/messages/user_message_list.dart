import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptmoe/messages/user_message_item.dart';
import 'package:jiffy/jiffy.dart';
import 'package:gptmoe/providers/firestore.dart';
import 'package:gptmoe/state/generic_state_notifier.dart';

final sortStateNotifierProvider =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

// String uid = FirebaseAuth.instance.currentUser!.uid;

class UserMessageList extends ConsumerWidget {
  const UserMessageList(this.uid, {super.key});

  final String? uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref.watch(colSP('user/$uid/message')).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          // more detailed version:
          // data: (data) {
          //   var arr = data.docs;
          //   arr.sort((a, b) => Jiffy(a.data()['timeCreated'].toDate())
          //           .isAfter(b.data()['timeCreated'].toDate())
          //       ? -1
          //       : 1);
          //   return (arr)
          //       .map((e) => UserVacancyItem(key: Key(e.id), e.reference))
          //       .toList();
          // }));
          // more concise version:
          data: (data) => (data.docs
                ..sort((a, b) => Jiffy(a.data()['timeCreated'].toDate())
                        .isAfter(b.data()['timeCreated'].toDate())
                    ? -1
                    : 1))
              .map((e) => UserMessageItem(key: Key(e.id), e.reference))
              .toList()));
}



/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:gptmoe/providers/firestore.dart';
import 'package:gptmoe/state/generic_state_notifier.dart';

import '../vacancies/user_message_item.dart';

final sortStateNotifierProvider =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

// String uid = FirebaseAuth.instance.currentUser!.uid;

class UserMessageList extends ConsumerWidget {
  String? uid;
  UserMessageList(this.uid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: ref.watch(colSP('user/$uid/message')).when(
          loading: () => [Container()],
          error: (e, s) => [ErrorWidget(e)],
          // more detailed version:
          // data: (data) {
          //   var arr = data.docs;
          //   arr.sort((a, b) => Jiffy(a.data()['timeCreated'].toDate())
          //           .isAfter(b.data()['timeCreated'].toDate())
          //       ? -1
          //       : 1);
          //   return (arr)
          //       .map((e) => UserVacancyItem(key: Key(e.id), e.reference))
          //       .toList();
          // }));
          // more concise version:
          data: (data) => (data.docs
                ..sort((a, b) => Jiffy(a.data()['timeCreated'].toDate())
                        .isAfter(b.data()['timeCreated'].toDate())
                    ? -1
                    : 1))
              .map((e) => UserMessageItem(key: Key(e.id), e.reference))
              .toList()));
}

*/