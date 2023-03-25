import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_chat.dart';
import 'package:chat_app_with_chatgpt/main/chatgpt/data/network/chatgpt_response_dto.dart';

abstract class ChatGptApiService {
  Future<ChatGptResponseDto?> fetchResponse(ChatGptChat chatGptChat, String question);
}
