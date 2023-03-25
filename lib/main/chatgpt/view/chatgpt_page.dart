import 'package:chat_app_with_chatgpt/core/chatgpt/usecase/ask_chatgpt_use_case.dart';
import 'package:chat_app_with_chatgpt/core/date_time_provider.dart';
import 'package:chat_app_with_chatgpt/main/chatgpt/bloc/chatgpt_bloc.dart';
import 'package:chat_app_with_chatgpt/main/chatgpt/bloc/chatgpt_message_type.dart';
import 'package:chat_app_with_chatgpt/main/chatgpt/bloc/chatgpt_message_view_model.dart';
import 'package:chat_app_with_chatgpt/main/chatgpt/data/gateway/chatgpt_repository_impl.dart';
import 'package:chat_app_with_chatgpt/main/chatgpt/data/network/chatgpt_api_service_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class ChatGptPage extends StatefulWidget {
  const ChatGptPage._({Key? key}) : super(key: key);

  static Widget create() => BlocProvider<ChatGptBloc>(
        create: (context) {
          final chatGptRepository = ChatGptRepositoryImpl(ChatGptApiServiceImpl());
          final askChatGptUseCase = AskChatGptUseCase(chatGptRepository);
          final dateTimeProvider = DateTimeProvider();
          return ChatGptBloc(askChatGptUseCase, dateTimeProvider);
        },
        child: const ChatGptPage._(),
      );

  @override
  State<ChatGptPage> createState() => _ChatGptPageState();
}

class _ChatGptPageState extends State<ChatGptPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  AppBar get _appbar => AppBar(title: const Text('Chat App powered by ChatGPT'));

  Widget get _inputBar => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextFormField(
          controller: _messageController,
          minLines: 1,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: 'Ask something',
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            contentPadding: const EdgeInsets.all(8),
            suffixIcon: IconButton(
              icon: Icon(Icons.send, color: Colors.green[500]),
              onPressed: () {
                context.read<ChatGptBloc>().add(AskQuestionEvent(_messageController.text));
                _messageController.clear();
              },
            ),
          ),
        ),
      );

  Widget get _chat => BlocConsumer<ChatGptBloc, List<ChatGptMessageViewModel>>(
        listener: (_, __) => _scrollToBottom(),
        builder: (context, viewModels) => CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: viewModels.length,
                (_, index) => _messageListTile(viewModels[index]),
              ),
            ),
          ],
        ),
      );

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  Widget _messageListTile(ChatGptMessageViewModel viewModel) {
    final isFromMe = viewModel.messageType == ChatGptMessageType.me;
    return ListTile(
      title: Align(
        alignment: isFromMe ? Alignment.topRight : Alignment.topLeft,
        child: viewModel.messageType == ChatGptMessageType.loading
            ? SizedBox(
                width: 100,
                height: 100,
                child: Lottie.asset('assets/lottie/chat_bubble_loading.json', fit: BoxFit.contain),
              )
            : _message(isFromMe, viewModel),
      ),
    );
  }

  Widget _message(bool isFromMe, ChatGptMessageViewModel viewModel) => Container(
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isFromMe ? Colors.green[500] : Colors.grey[600],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isFromMe ? const Radius.circular(20) : const Radius.circular(0),
            bottomRight: isFromMe ? const Radius.circular(0) : const Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          viewModel.message,
          style: const TextStyle(color: Colors.white),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appbar,
        body: Container(
          color: Colors.grey[150],
          child: Column(
            children: [
              Expanded(child: _chat),
              _inputBar,
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
