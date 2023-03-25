class ChatGptChat {
  ChatGptChat();

  final List<Map<String, String>> chatLogs = [];

  void add(String userInput, String chatGptSummary) {
    chatLogs
      ..add({
        'role': 'user',
        'content': userInput,
      })
      ..add({
        'role': 'assistant',
        'content': chatGptSummary,
      });
  }
}
