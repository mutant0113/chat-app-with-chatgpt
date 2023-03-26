import 'package:equatable/equatable.dart';

class ChatGptResponse with EquatableMixin {
  ChatGptResponse(
    this.response, {
    String? summary,
    List<String>? keywords,
  })  : summary = summary ?? response,
        keywords = keywords ?? [];

  final String response;
  final String summary;
  final List<String> keywords;

  @override
  List<Object?> get props => [response, summary, keywords];
}
