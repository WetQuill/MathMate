import 'package:flutter/material.dart';
import 'package:mathmate/data/conversation_models.dart';
import 'package:mathmate/data/conversation_repository.dart';
import 'package:mathmate/services/vivo_chat_service.dart';

class ChatPage extends StatefulWidget {
  /// 可选的初始查询，从搜索框传入
  final String? initialQuery;

  /// 加载已有对话时传入；null 表示创建新对话
  final int? conversationId;

  /// 新对话创建后回调（用于父组件更新侧边栏）
  final void Function(int id)? onConversationCreated;

  /// 对话标题变更回调
  final void Function(String title)? onTitleChanged;

  const ChatPage({
    super.key,
    this.initialQuery,
    this.conversationId,
    this.onConversationCreated,
    this.onTitleChanged,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final VivoAiChatService _chatService = VivoAiChatService();
  final ConversationRepository _repo = ConversationRepository.instance;
  final TextEditingController _inputController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  final List<VivoChatMessage> _historyMessages = <VivoChatMessage>[];

  bool _isLoading = false;
  int? _conversationId;
  bool _titleGenerated = false;

  static const String _systemPrompt =
      '你是一个专业的数学辅导助手，名为蓝心。你应该用友好、专业的态度回答用户提出的数学问题，帮助用户理解和解决数学难题。如果用户问的不是数学问题，你可以友善地引导他们回到数学话题上。';

  @override
  void initState() {
    super.initState();
    _historyMessages.add(
      VivoChatMessage(role: 'system', content: _systemPrompt),
    );

    _conversationId = widget.conversationId;

    // 加载已有对话
    if (_conversationId != null) {
      _loadConversation(_conversationId!);
    }

    // 如果有初始查询，等待首帧后自动发送
    if (widget.initialQuery != null && widget.initialQuery!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(text: widget.initialQuery!.trim());
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation(int id) async {
    final Conversation? conversation = await _repo.getConversation(id);
    if (conversation == null || !mounted) return;

    setState(() {
      _messages.clear();
      for (final ChatMessageEmbedded msg in conversation.messages) {
        // system 消息不显示在 UI 中（已在 _historyMessages 中）
        if (msg.role != 'system') {
          _messages.add(ChatMessage(role: msg.role, content: msg.content));
        }
        _historyMessages.add(
          VivoChatMessage(role: msg.role, content: msg.content),
        );
      }
      _titleGenerated = conversation.messages.isNotEmpty;
    });
  }

  /// 从首条用户消息截取标题（最多15个字符）
  String _generateTitle(String content) {
    final String trimmed = content.trim();
    if (trimmed.length <= 15) return trimmed;
    return '${trimmed.substring(0, 15)}…';
  }

  /// 确保对话已创建（首次发送消息时调用）
  Future<int> _ensureConversation(String title) async {
    if (_conversationId != null) return _conversationId!;

    final Conversation conversation = await _repo.createConversation(title);
    _conversationId = conversation.id;
    widget.onConversationCreated?.call(conversation.id);
    return conversation.id;
  }

  Future<void> _sendMessage({String? text}) async {
    final String message = (text ?? _inputController.text).trim();
    if (message.isEmpty || _isLoading) return;

    _inputController.clear();

    final DateTime now = DateTime.now();
    final int convId = await _ensureConversation(_generateTitle(message));

    setState(() {
      _messages.add(ChatMessage(role: 'user', content: message));
      _isLoading = true;
    });

    _historyMessages.add(VivoChatMessage(role: 'user', content: message));

    // 持久化用户消息
    await _repo.addMessage(
      convId,
      ChatMessageEmbedded()
        ..role = 'user'
        ..content = message
        ..timestamp = now,
    );

    // 首次对话自动生成标题
    if (!_titleGenerated) {
      _titleGenerated = true;
      widget.onTitleChanged?.call(_generateTitle(message));
    }

    try {
      final String response = await _chatService.sendMessage(_historyMessages);
      _historyMessages.add(
        VivoChatMessage(role: 'assistant', content: response),
      );

      // 持久化助手回复
      await _repo.addMessage(
        convId,
        ChatMessageEmbedded()
          ..role = 'assistant'
          ..content = response
          ..timestamp = DateTime.now(),
      );

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(role: 'assistant', content: response));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('发送失败: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _messages.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildMessageBubble(_messages[index]);
                  },
                ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.auto_awesome, size: 64, color: Color(0xFF3F51B5)),
          SizedBox(height: 16),
          Text(
            '你好！我是蓝心数学助手',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3F51B5),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '可以问我任何数学问题哦~',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF3F51B5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.content,
          style: TextStyle(
            fontSize: 15,
            color: isUser ? Colors.white : const Color(0xFF333333),
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: '输入数学问题...',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF3F51B5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String role;
  final String content;

  ChatMessage({required this.role, required this.content});
}
