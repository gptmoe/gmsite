import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gptmoe/controls/doc_field_text_edit.dart';

class Sandbox extends StatelessWidget {
  const Sandbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: Colors.grey,
            )),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            ListTile(
              title: DocFieldTextEdit2(
                  FirebaseFirestore.instance.doc('/dev/serge/text_edit/1'),
                  'the_field'),
            ),
            const ListTile(
              title: Text('Text Widget 1'),
            )
          ],
        ));
  }
}
