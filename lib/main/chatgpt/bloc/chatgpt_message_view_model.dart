import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_response.dart';
import 'package:chat_app_with_chatgpt/main/chatgpt/bloc/chatgpt_message_type.dart';
import 'package:equatable/equatable.dart';

class ChatGptMessageViewModel with EquatableMixin {
  ChatGptMessageViewModel.fromMe({
    required this.message,
    required this.timestamp,
  }) : messageType = ChatGptMessageType.me;

  ChatGptMessageViewModel.fromBot({
    required ChatGptResponse chatGptResponse,
    required this.timestamp,
  })  : messageType = ChatGptMessageType.chatGpt,
        message = chatGptResponse.response;

  ChatGptMessageViewModel.loading({required this.timestamp})
      : messageType = ChatGptMessageType.loading,
        message = '';

  final ChatGptMessageType messageType;
  final String message;
  final DateTime timestamp;

  @override
  List<Object?> get props => [messageType, message, timestamp];
}
