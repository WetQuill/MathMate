import 'package:flutter/material.dart';
import 'package:mathmate/chat_page.dart';
import 'package:mathmate/data/conversation_models.dart';
import 'package:mathmate/data/conversation_repository.dart';

class ChatHomePage extends StatefulWidget {
  /// 从搜索框传入的初始查询
  final String? initialQuery;

  const ChatHomePage({super.key, this.initialQuery});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final ConversationRepository _repo = ConversationRepository.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? _currentConversationId;
  String _currentTitle = '蓝心数学助手';

  @override
  void initState() {
    super.initState();
    // 启动时创建新对话（无 ID）
    _currentConversationId = null;
  }

  void _onConversationCreated(int id) {
    setState(() {
      _currentConversationId = id;
    });
  }

  void _onTitleChanged(String title) {
    if (mounted && _currentConversationId != null) {
      setState(() {
        _currentTitle = title;
      });
      // 同步更新 DB 中的标题
      _repo.updateTitle(_currentConversationId!, title);
    }
  }

  void _switchConversation(Conversation conversation) {
    setState(() {
      _currentConversationId = conversation.id;
      _currentTitle = conversation.title;
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  void _newConversation() {
    setState(() {
      _currentConversationId = null;
      _currentTitle = '蓝心数学助手';
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  Future<void> _deleteConversation(Conversation conversation) async {
    await _repo.deleteConversation(conversation.id);
    if (_currentConversationId == conversation.id) {
      _newConversation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        title: Text(
          _currentTitle,
          style: const TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3F51B5),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            tooltip: '对话历史',
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: ChatPage(
        key: ValueKey<int?>(_currentConversationId),
        initialQuery: _currentConversationId == null ? widget.initialQuery : null,
        conversationId: _currentConversationId,
        onConversationCreated: _onConversationCreated,
        onTitleChanged: _onTitleChanged,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 顶部标题
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: const Text(
                '对话历史',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
            ),

            // 新对话按钮
            Padding(
              padding: const EdgeInsets.all(12),
              child: FilledButton.icon(
                onPressed: _newConversation,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('新对话'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const Divider(height: 1),

            // 对话列表
            Expanded(
              child: StreamBuilder<List<Conversation>>(
                stream: _repo.watchConversations(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Conversation>> snapshot,
                ) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.chat_bubble_outline,
                              size: 40, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text(
                            '暂无对话记录',
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }

                  final List<Conversation> conversations = snapshot.data!;
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: conversations.length,
                    separatorBuilder: (ctx, i) =>
                        Divider(height: 1, indent: 16, color: Colors.grey.shade100),
                    itemBuilder: (BuildContext context, int index) {
                      final Conversation conversation = conversations[index];
                      final bool isActive =
                          _currentConversationId == conversation.id;

                      return Ink(
                        color: isActive ? const Color(0xFFE8EEFF) : null,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          title: Text(
                            conversation.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight:
                                  isActive ? FontWeight.w600 : FontWeight.w400,
                              color: isActive
                                  ? const Color(0xFF3F51B5)
                                  : const Color(0xFF333333),
                            ),
                          ),
                          subtitle: Text(
                            _formatTime(conversation.updatedAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          onTap: () => _switchConversation(conversation),
                          onLongPress: () => _showDeleteDialog(conversation),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Conversation conversation) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('删除对话'),
          content: Text('确定删除「${conversation.title}」？'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _deleteConversation(conversation);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('删除'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    final Duration diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    return '${time.month}/${time.day}';
  }
}
