import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:gptmoe/features/home/pages/home_page.dart';

import '../services/chat_gpt_service.dart';

String _apiKey = '';

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
    required this.room,
  });

  final types.Room room;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text('Chat'),
          leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => route.isFirst,
              );
            },
          ),
        ),
        body: StreamBuilder<types.Room>(
          initialData: room,
          stream: FirebaseChatCore.instance.room(room.id),
          builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
            initialData: const [],
            stream: FirebaseChatCore.instance.messages(snapshot.data!),
            builder: (context, snapshot) {
              final allMessages = snapshot.data ?? [];

              return Chat(
                messages: allMessages,
                onPreviewDataFetched: _handlePreviewDataFetched,
                onSendPressed: (message) => _handleSendPressed(
                  context,
                  message: message,
                  allMessages: allMessages,
                ),
                user: types.User(
                  id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                ),
              );
            },
          ),
        ),
      );

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, room.id);
  }

  void _handleSendPressed(
    BuildContext context, {
    required types.PartialText message,
    required List<types.Message> allMessages,
  }) async {
    if (_apiKey.isEmpty) {
      final apiKey = await _showApiKeyBottomSheet(context);
      if (apiKey == null || apiKey.isEmpty) {
        return;
      }
      _apiKey = apiKey;
    }

    try {
      FirebaseChatCore.instance.sendMessage(
        message,
        room.id,
      );

      await ChatGptService.sendReplyMessageFromChatGpt(
        roomId: room.id,
        recentMessage: message.text,
        allMessages: allMessages,
        openApiKey: _apiKey,
      );
      // TODO(zharfan104): Handle specific error
    } catch (_) {
      _apiKey = '';
      // ignore: use_build_context_synchronously
      await _showApiKeyBottomSheet(context, inputLabel: 'Invalid API Key, please input again');
    }
  }

  Future<String?> _showApiKeyBottomSheet(
    BuildContext context, {
    String inputLabel = 'Input OpenAI API Key',
  }) async {
    final apiKeyController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  controller: apiKeyController,
                  decoration: InputDecoration(
                    labelText: inputLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter API key';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context, apiKeyController.text.trim());
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
