import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firestore.dart';
import 'admin_viewpage.dart';
import 'message_details_page.dart';

class UserMessageItem extends ConsumerWidget {
  final DocumentReference searchRef;
  // const SearchListItem(this.searchRef);
  final TextEditingController ctrl = TextEditingController();

  UserMessageItem(this.searchRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(docSP(searchRef.path)).when(
        loading: () => Container(),
        error: (e, s) => ErrorWidget(e),
        data: (searchDoc) => Card(
                child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Flexible(flex: 1, child: Text('vac ')),
                      Flexible(
                          flex: 1,
                          child: Text(
                            (searchDoc.data()!['text'] ?? ''),
                            style: Theme.of(context).textTheme.bodyLarge,
                          )),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: const Text('details'),
                              content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    searchDoc.data()!['text'],
                                  )),
                              actions: [
                                TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    })
                              ],
                            );
                          });
                    },
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.delete),
                  //   onPressed: () {
                  //     showDialog(
                  //         context: context,
                  //         builder: (BuildContext context) {
                  //           return AlertDialog(
                  //             scrollable: true,
                  //             title: Text('Delete Sentence...'),
                  //             content: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Text('Are you sure?')),
                  //             actions: [
                  //               TextButton(
                  //                   child: Text("Yes"),
                  //                   onPressed: () {
                  //                     searchRef.delete();
                  //                     Navigator.of(context).pop();
                  //                   }),
                  //               TextButton(
                  //                   child: Text("Cancel"),
                  //                   onPressed: () {
                  //                     Navigator.of(context).pop();
                  //                   })
                  //             ],
                  //           );
                  //         });
                  //   },
                  // ))
                  //,
                  // subtitle: Text(entityDoc.data()!['desc'] ?? 'desc'),
                  // trailing: Column(children: <Widget>[
                  //   Text(searchDoc.data()!['target'] ?? ''),
                  //   // buildDeleteEntityButton(
                  //   //     context,
                  //   //     FirebaseFirestore.instance
                  //   //         .collection('batch')
                  //   //         .doc(batchId),
                  //   //     Icon(Icons.delete))
                  // ]),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MessageDetailsPage.routeName,
                      arguments: PageArguments(
                        searchDoc.id,
                        'This message is extracted in the build method.',
                      ),
                    );
                  },
                )
              ],
            )));
  }
}
