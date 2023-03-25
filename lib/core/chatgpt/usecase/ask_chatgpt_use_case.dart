import 'package:chat_app_with_chatgpt/core/chatgpt/data/chatgpt_repository.dart';
import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_chat.dart';
import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_response.dart';

class AskChatGptUseCase {
  AskChatGptUseCase(this._repository);

  final ChatGptRepository _repository;

  Future<ChatGptResponse?> call(
    ChatGptChat chatGptChat,
    String question,
  ) =>
      _repository.askQuestion(chatGptChat, question);
}
