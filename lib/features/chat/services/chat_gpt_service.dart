import 'dart:convert';

import "package:chat_gpt_sdk/chat_gpt_sdk.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_chat_types/flutter_chat_types.dart" as types;
import "package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart";

import "../../../resources/constants/chat_gpt_user.dart";
import '../models/principle.dart';
import '../models/principles.dart';
import '../utils/extract_conversation.dart';
import '../utils/get_prompt.dart';

const _kLastMessageCount = 3;

class ChatGptService {
  static final _openAI = OpenAI.instance.build(
    token: '<< REPLACE WITH YOUR API KEY HERE>>',
    baseOption: HttpSetup(receiveTimeout: 6000),
    isLogger: true,
  );

  static void sendReplyMessageFromChatGpt({
    required String roomId,
    required String recentMessage,
    required List<types.Message> allMessages,
  }) async {
    try {
      final userId = FirebaseChatCore.instance.firebaseUser!.uid;

      final lastMessageFromChatGpt = convertMessageToString(allMessages.first);
      final lastMessageFromUser = convertMessageToString(types.TextMessage(
        id: '',
        author: types.User(id: userId),
        text: recentMessage,
      ));

      final lastTwoConversation =
          '$lastMessageFromChatGpt\n$lastMessageFromUser';

      final principlesFromCurrentConversation =
          await _convertConversationToPrinciples(lastTwoConversation);

      String principlesFromCurrentConversationStringify =
          await _getStoredPrinciplesBasedOnCurrentConversationPrinciples(
        principlesFromCurrentConversation,
      );

      final lastMessagesStringify = allMessages
          .take(_kLastMessageCount)
          .map(convertMessageToString)
          .toString();

      final prompt = getPrompt(
        recentMessage: recentMessage,
        allMessagesStringify: lastMessagesStringify,
        principlesFromCurrentConversationStringify:
            principlesFromCurrentConversationStringify,
      );

      final response = await _sendPromptToOpenAI(prompt);

      await _storeChatGptMessageToFireStore(response, roomId);

      await _storePrinciplesBasedOnCurrentConversation(
        principlesFromCurrentConversation,
      );
    } catch (_) {
      final prompt = getPrompt(
        recentMessage: recentMessage,
        allMessagesStringify: '',
        principlesFromCurrentConversationStringify: '',
      );
      final response = await _sendPromptToOpenAI(prompt);

      await _storeChatGptMessageToFireStore(response, roomId);
    }
  }

  static Future<String>
      _getStoredPrinciplesBasedOnCurrentConversationPrinciples(
    List<Principle> principles,
  ) async {
    String principleStringify = '';

    // Loop through the tags and update the Firestore documents with the extracted principles
    for (var principle in principles) {
      for (final tag in principle.tags) {
        final tagCollectionRef = FirebaseFirestore.instance
            .collection(FirebaseChatCore.instance.config.usersCollectionName)
            .doc(FirebaseChatCore.instance.firebaseUser?.uid)
            .collection("memory")
            .doc(tag)
            .collection('principle');

        final collection = await tagCollectionRef.get();

        for (var doc in collection.docs) {
          principleStringify = '$principles${doc.id} at ${doc.data()}\n';
        }
      }
    }

    return principleStringify;
  }

  static Future<void> _storePrinciplesBasedOnCurrentConversation(
    List<Principle> principles,
  ) async {
    // Loop through the tags and update the Firestore documents with the extracted principles
    for (var principle in principles) {
      for (final tag in principle.tags) {
        final tagDocRef = FirebaseFirestore.instance
            .collection(FirebaseChatCore.instance.config.usersCollectionName)
            .doc(FirebaseChatCore.instance.firebaseUser?.uid)
            .collection("memory")
            .doc(tag)
            .collection('principle')
            .doc(principle.text);

        await tagDocRef.set({
          'createdAt': DateTime.now(),
        }, SetOptions(merge: true));
      }
    }
  }

  static Future<void> _storeChatGptMessageToFireStore(
    String response,
    String roomId,
  ) async {
    final message = types.TextMessage.fromPartial(
      id: "",
      author: chatGptUser,
      partialText: types.PartialText(text: response),
    );
    final messageMap = message.toJson();
    messageMap.removeWhere((key, value) => key == "author" || key == "id");
    messageMap["authorId"] = chatGptUser.id;
    messageMap["createdAt"] = FieldValue.serverTimestamp();
    messageMap["updatedAt"] = FieldValue.serverTimestamp();

    await FirebaseChatCore.instance
        .getFirebaseFirestore()
        .collection(
            "${FirebaseChatCore.instance.config.roomsCollectionName}/$roomId/messages")
        .add(messageMap);
  }

  static Future<String> _sendPromptToOpenAI(String prompt) async {
    final response = await _openAI.onCompleteText(
      request: CompleteText(
        prompt: prompt,
        model: kTranslateModelV3,
      ),
    );
    return response!.choices.first.text.trim();
  }

  static Future<List<Principle>> _convertConversationToPrinciples(
      String conversation) async {
    final prompt = extractConversation(conversation);

    final response = await _sendPromptToOpenAI(prompt);

    final principles =
        Principles.fromJson(json.decode(response) as Map<String, dynamic>);

    return principles.list;
  }

  static String convertMessageToString(types.Message message) {
    return """
      {
      id: ${message.author.id}
      createdAt: ${message.author.createdAt}
      message: ${(message as types.TextMessage).text}
      }
      """;
  }
}
