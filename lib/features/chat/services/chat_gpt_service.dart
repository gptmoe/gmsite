import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../../resources/constants/chat_gpt_user.dart';

class ChatGptService {
  static final openAI = OpenAI.instance.build(
    token: '<< REPLACE WITH YOUR API KEY HERE>>',
    baseOption: HttpSetup(receiveTimeout: 6000),
    isLogger: true,
  );

  static void sendReplyMessageFromChatGpt(
    String prompt,
    String roomId,
  ) async {
    final request = CompleteText(
      prompt: prompt,
      model: kTranslateModelV3,
    );

    final response = await openAI.onCompleteText(request: request);

    final message = types.TextMessage.fromPartial(
      author: chatGptUser,
      id: '',
      partialText: types.PartialText(
          text: response!.choices.first.text.replaceAll('\n', '')),
    );

    final messageMap = message.toJson();
    messageMap.removeWhere((key, value) => key == 'author' || key == 'id');
    messageMap['authorId'] = 'user_id';
    messageMap['createdAt'] = FieldValue.serverTimestamp();
    messageMap['updatedAt'] = FieldValue.serverTimestamp();

    await FirebaseChatCore.instance
        .getFirebaseFirestore()
        .collection(
            '${FirebaseChatCore.instance.config.roomsCollectionName}/$roomId/messages')
        .add(messageMap);

    await FirebaseChatCore.instance
        .getFirebaseFirestore()
        .collection(FirebaseChatCore.instance.config.roomsCollectionName)
        .doc(roomId)
        .update({'updatedAt': FieldValue.serverTimestamp()});
  }
}
