import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gptmoe/app_bar.dart';
import 'package:gptmoe/common.dart';
import 'package:gptmoe/state/generic_state_notifier.dart';
import 'package:gptmoe/drawer.dart';
import 'package:gptmoe/messages/user_message_list.dart';
import 'package:http/http.dart' as http;

final activeBatch =
    StateNotifierProvider<GenericStateNotifier<String?>, String?>(
        (ref) => GenericStateNotifier<String?>(null));

final firestoreInstance = FirebaseFirestore.instance;

class UserMessagesPage extends ConsumerWidget {
  final TextEditingController searchCtrl = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: MyAppBar.getBar(context, ref),
      drawer: (MediaQuery.of(context).size.width < WIDE_SCREEN_WIDTH)
          ? TheDrawer.buildDrawer(context)
          : null,
      body: Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: UserMessageList(uid)),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextField(
                          style: Theme.of(context).textTheme.headline3,
                          onChanged: (v) {},
                          controller: searchCtrl)),
                  ElevatedButton(
                      child: Text(
                        "Send",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      onPressed: () async {
                        if (searchCtrl.text.isEmpty) return;
                        print(uid);
                        //fetchAlbum(searchCtrl.text);
                        firestoreInstance
                            .collection("user")
                            .doc(uid)
                            .collection("message")
                            .add({
                          'text': searchCtrl.text,
                          'timeCreated': FieldValue.serverTimestamp(),
                          'author': FirebaseAuth.instance.currentUser!.uid,
                        });
                        searchCtrl.clear();
                      })
                ],
              ),
            ],
          )),
    );
  }

  dynamic fetchAlbum(String url) async {
    print('fetching $url');
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('fail');
      throw Exception('Failed to load album');
    }
  }
}
