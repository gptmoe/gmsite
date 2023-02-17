import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptmoe/admin_viewpage.dart';
import 'package:gptmoe/providers/firestore.dart';
import 'package:gptmoe/user_viewpage.dart';

class ChooseUserViewWidget extends ConsumerWidget {
  const ChooseUserViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(docSP('admin/${FirebaseAuth.instance.currentUser!.uid}')).when(
          loading: () => Container(),
          error: (e, s) => ErrorWidget(e),
          data: (doc) =>
              (doc.exists) ? const AdminViewWidget() : const UserViewWidget());
}
