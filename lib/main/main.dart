import 'package:chat_app_with_chatgpt/main/chatgpt/view/chatgpt_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Chat App with chatGPT Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ChatGptPage.create(),
      );
}
