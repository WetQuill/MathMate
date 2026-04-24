import 'package:isar/isar.dart';

part 'conversation_models.g.dart';

@collection
class Conversation {
  Id id = Isar.autoIncrement;

  late String title;
  late DateTime createdAt;
  late DateTime updatedAt;

  // 使用 @enclosed 嵌入消息列表
  List<ChatMessageEmbedded> messages = <ChatMessageEmbedded>[];
}

@embedded
class ChatMessageEmbedded {
  late String role; // 'user' | 'assistant' | 'system'
  late String content;
  late DateTime timestamp;
}
