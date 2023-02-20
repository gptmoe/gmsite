import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptmoe/core/utils/state/generic_state_notifier.dart';

import '../../../core/providers/firestore.dart';
import '../../chat/pages/user_message_list.dart';

final activeUser =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

class UserDetails extends ConsumerWidget {
  final String? entityId;

  final TextEditingController idCtrl = TextEditingController(),
      nameCtrl = TextEditingController(),
      descCtrl = TextEditingController();

  UserDetails(
    this.entityId, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => entityId == null
      ? Container()
      : ref.watch(docSP('user/${entityId!}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (userDoc) => Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: Colors.grey,
                  )),
              child: Column(children: [
                Text(userDoc.id),
                Text('name: ${userDoc.data()!['name'] ?? ''}'),
                Text('email: ${userDoc.data()!['email'] ?? ''}'),
                const Divider(),
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
                    const VerticalDivider(),
                    const Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          child: Text('User Resume List Widget goes here'),
                          // child: UserResumeListWidget(userDoc.id),
                        )),
                    const VerticalDivider(),
                    const Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          child: Text(
                              'User FAQ List Widget goes here'), // Replace with UserFAQListWidget(userDoc.id)
                        ))
                  ],
                )
              ])));
}
