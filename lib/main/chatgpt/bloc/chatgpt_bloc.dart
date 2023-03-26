import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_chat.dart';
import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_response.dart';
import 'package:chat_app_with_chatgpt/core/chatgpt/usecase/ask_chatgpt_use_case.dart';
import 'package:chat_app_with_chatgpt/core/date_time_provider.dart';
import 'package:chat_app_with_chatgpt/main/chatgpt/bloc/chatgpt_message_view_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatGptBloc extends Bloc<AskQuestionEvent, List<ChatGptMessageViewModel>> {
  ChatGptBloc(
    this._askChatGptUseCase,
    this._dateTimeProvider,
  ) : super(_initialState(_dateTimeProvider)) {
    _chatGptResponseViewModels.addAll(state);
    on<AskQuestionEvent>((event, emit) async {
      _chatGptResponseViewModels.add(
        ChatGptMessageViewModel.fromMe(
          message: event.question,
          timestamp: _dateTimeProvider.now(),
        ),
      );
      emit(_chatGptResponseViewModels);

      _chatGptResponseViewModels.add(
        ChatGptMessageViewModel.loading(timestamp: _dateTimeProvider.now()),
      );
      emit(_chatGptResponseViewModels);

      final chatGptResponse = await _askChatGptUseCase(_chatGptChat, event.question);
      print('mutant, chatGptResponse: $chatGptResponse');

      _chatGptResponseViewModels.removeLast();
      _chatGptResponseViewModels.add(
        ChatGptMessageViewModel.fromBot(
          chatGptResponse: chatGptResponse ?? ChatGptResponse('System error, please try again'),
          timestamp: _dateTimeProvider.now(),
        ),
      );
      emit(List.of(_chatGptResponseViewModels));

      if (chatGptResponse != null) {
        _chatGptChat.add(event.question, chatGptResponse.summary);
      }
    });
  }

  static List<ChatGptMessageViewModel> _initialState(DateTimeProvider dateTimeProvider) => [
        ChatGptMessageViewModel.fromBot(
          chatGptResponse: ChatGptResponse(
            'Hi, I\'m your shopping assistant.\nPlease ask me some questions.'.trim(),
          ),
          timestamp: dateTimeProvider.now(),
        )
      ];

  final ChatGptChat _chatGptChat = ChatGptChat();
  final List<ChatGptMessageViewModel> _chatGptResponseViewModels = [];
  final AskChatGptUseCase _askChatGptUseCase;
  final DateTimeProvider _dateTimeProvider;
}

class AskQuestionEvent {
  const AskQuestionEvent(this.question);

  final String question;
}
