import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_chat.dart';
import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_response.dart';

abstract class ChatGptRepository {
  Future<ChatGptResponse?> askQuestion(ChatGptChat chatGptChat, String question);
}
