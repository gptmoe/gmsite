import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_chat_types/flutter_chat_types.dart" as types;
import "package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart";

import "../../../resources/constants/chat_gpt_user.dart";
import 'open_ai_service.dart';

class ChatGptService {
  /// Sends a reply message from the GPT-3 chatbot to the specified room ID in Firebase.
  ///
  /// Given a recent message and a list of all messages in the room, the method will extract
  /// principles from the last two conversations, generate a prompt for the GPT-3 API using
  /// the extracted principles, and send the prompt to the API to generate a response. The
  /// response is then stored in Firestore and returned.
  ///
  /// Notes: This method will extract principles from the last two conversations and save them to
  /// Firestore for future use.
  static Future<void> sendReplyMessageFromChatGpt({
    required String roomId,
    required String recentMessage,
    required List<types.Message> allMessages,
    required String openApiKey,
  }) async {
    final userId = FirebaseChatCore.instance.firebaseUser!.uid;

    final response = await OpenAiService.sendPromptToOpenAi(
      userId: userId,
      prompt: recentMessage,
      openApiKey: openApiKey,
    );

    await _storeChatGptMessageToFireStore(response, roomId);
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
        .collection("${FirebaseChatCore.instance.config.roomsCollectionName}/$roomId/messages")
        .add(messageMap);
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
