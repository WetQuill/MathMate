import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

import 'conversation_models.dart';

class ConversationRepository {
  ConversationRepository._();
  static final ConversationRepository instance = ConversationRepository._();

  Isar? _isar;

  bool get isReady => _isar != null;

  Future<void> init() async {
    if (_isar != null) return;

    final Directory dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      <CollectionSchema>[ConversationSchema],
      directory: dir.path,
      name: 'mathmate_chat',
    );
  }

  /// 创建新对话，返回带 id 的 Conversation
  Future<Conversation> createConversation(String title) async {
    await init();
    final Conversation conversation = Conversation()
      ..title = title
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await _isar!.writeTxn(() async {
      await _isar!.conversations.put(conversation);
    });

    return conversation;
  }

  /// 向对话追加消息并更新 updatedAt
  Future<void> addMessage(
    int conversationId,
    ChatMessageEmbedded message,
  ) async {
    await init();
    final Conversation? conversation =
        await _isar!.conversations.get(conversationId);
    if (conversation == null) return;

    conversation.messages.add(message);
    conversation.updatedAt = message.timestamp;

    await _isar!.writeTxn(() async {
      await _isar!.conversations.put(conversation);
    });
  }

  /// 更新对话标题
  Future<void> updateTitle(int conversationId, String title) async {
    await init();
    final Conversation? conversation =
        await _isar!.conversations.get(conversationId);
    if (conversation == null) return;

    conversation.title = title;

    await _isar!.writeTxn(() async {
      await _isar!.conversations.put(conversation);
    });
  }

  /// 监听所有对话（按更新时间倒序）
  Stream<List<Conversation>> watchConversations() async* {
    await init();
    final Isar isar = _isar!;
    yield* isar.conversations.where().sortByUpdatedAtDesc().watch(
          fireImmediately: true,
        );
  }

  /// 获取单个对话
  Future<Conversation?> getConversation(int id) async {
    await init();
    return _isar!.conversations.get(id);
  }

  /// 删除对话
  Future<void> deleteConversation(int id) async {
    await init();
    await _isar!.writeTxn(() async {
      await _isar!.conversations.delete(id);
    });
  }
}
