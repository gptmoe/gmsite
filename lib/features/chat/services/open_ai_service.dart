import 'dart:convert';

import 'package:dio/dio.dart';

class OpenAiService {
  static Future<String> sendPromptToOpenAi({
    required String userId,
    required String prompt,
    required String openApiKey,
  }) async {
    const url = 'https://zharfan104.pythonanywhere.com/';

    final requestBody = {
      "open_ai_key": openApiKey,
      "user_id": userId,
      "prompt": prompt,
    };

    final headers = {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };

    final dio = Dio();
    final response = await dio.post(
      url,
      data: jsonEncode(requestBody),
      options: Options(
        headers: headers,
      ),
    );

    // Handle the response
    if (response.statusCode == 200) {
      print('API response: ${response.data['response']}');

      return response.data['response'] as String;
    }

    throw DioError(requestOptions: response.requestOptions);
  }
}
