import 'package:equatable/equatable.dart';

class ChatGptResponse with EquatableMixin {
  ChatGptResponse(this.response, {String? summary}) : summary = summary ?? response;

  final String response;
  final String summary;

  @override
  List<Object?> get props => [response, summary];
}
