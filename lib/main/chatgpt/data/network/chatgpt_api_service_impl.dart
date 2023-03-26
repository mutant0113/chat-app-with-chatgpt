import 'dart:convert';

import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_chat.dart';
import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_config.dart';
import 'package:chat_app_with_chatgpt/main/chatgpt/data/network/chatgpt_api_service.dart';
import 'package:chat_app_with_chatgpt/main/chatgpt/data/network/chatgpt_response_dto.dart';
import 'package:dio/dio.dart';

class ChatGptApiServiceImpl implements ChatGptApiService {
  @override
  Future<ChatGptResponseDto?> fetchResponse(ChatGptChat chatGptChat, String question) async {
    const url = 'https://api.openai.com/v1/chat/completions';

    final dio = Dio()
      ..options.headers['Authorization'] = 'Bearer ${ChatGptConfig.apiKey}'
      ..options.headers['Content-Type'] = 'application/json';

    final requestBody = jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {
          'role': 'system',
          'content': '''
          ${ChatGptConfig.systemRole}
          After answering the questions, use the prefix "json:" followed by the conversation content to convert it into the defined json format. If there is no value for the fields, please fill it with null. Please try to fill in the json content as much as possible during the conversation, and make sure to reply with the json format.
          Here are the definitions of fields:
          1. keyword: Keywords that can be used for Google search during a conversation, including search keywords, recommended brand names, recommended brand models, and so on.
          2. summary: summary of response (less than 50 words)
          --------
          Response Format：
          Main content reply
          json:
          {
            "keyword": [
              "search keyword",
              "recommended brand name 1",
              "recommended brand model 2",
            ],
            "summary": "summary of response"
          } 
          '''
              .trim(),
        },
        for (final chatLog in chatGptChat.chatLogs) chatLog,
        {'role': 'user', 'content': question},
      ],
    });

    print('mutant, chatGpt: Start Post');
    final Response<String> response = await dio.post(url, data: requestBody);
    print('mutant, chatGpt: End Post');
    final data = response.data;
    if (response.statusCode == 200 && data != null) {
      final answer = json.decode(data) as Map<String, dynamic>;
      final text = answer['choices'][0]['message']['content'] as String;
      print('mutant, chatGpt: Response: $text');
      return ChatGptResponseDto(text);
    } else {
      print('mutant, chatGpt: Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
