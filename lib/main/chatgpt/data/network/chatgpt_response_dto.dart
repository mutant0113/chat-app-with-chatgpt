import 'dart:convert';

import 'package:chat_app_with_chatgpt/core/chatgpt/domain/chatgpt_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatgpt_response_dto.g.dart';

@JsonSerializable()
class ChatGptResponseDto {
  ChatGptResponseDto(this.response);

  factory ChatGptResponseDto.fromJson(Map<String, dynamic> json) => _$ChatGptResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatGptResponseDtoToJson(this);

  final String response;

  ChatGptResponse toChatGptResponse() {
    final splittedString = response.split('json:');
    final hasJsonData = splittedString.length > 1;
    if (!hasJsonData) {
      return ChatGptResponse(splittedString.first.trim());
    }

    final jsonString = splittedString.last.trim().replaceAll('`', '').replaceAll('json:', '');
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return ChatGptResponse(splittedString.first.trim(), summary: jsonMap['summary'] as String?);
  }
}
