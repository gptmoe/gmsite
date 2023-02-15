import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptmoe/providers/firestore.dart';
import 'package:gptmoe/state/generic_state_notifier.dart';

import '../messages/user_message_list.dart';

final activeUser =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class UserDetails extends ConsumerWidget {
  final String? entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  UserDetails(this.entityId);

  @override
  Widget build(BuildContext context, WidgetRef ref) => entityId == null
      ? Container()
      : ref.watch(docSP('user/${entityId!}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (userDoc) => Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Colors.grey,
                  )),
              child: Column(children: [
                Text(userDoc.id),
                Text('name: ${userDoc.data()!['name'] ?? ''}'),
                Text('email: ${userDoc.data()!['email'] ?? ''}'),
                Divider(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        width: 400,
                        height: MediaQuery.of(context).size.height - 180,
                        // child: Text(
                        //     'User Vacancy List Widget goes here'), // Replace with UserVacancyListWidget(userDoc.id)
                        child: UserMessageList(userDoc.id),
                        // child: UserVacancyItem(key: Key(userDoc.id), userDoc.reference),
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          child: Text('User Resume List Widget goes here'),
                          // child: UserResumeListWidget(userDoc.id),
                        )),
                    VerticalDivider(),
                    Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          child: Text(
                              'User FAQ List Widget goes here'), // Replace with UserFAQListWidget(userDoc.id)
                        ))
                  ],
                )
              ])));
}
