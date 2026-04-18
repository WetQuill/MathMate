import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('账户设置')),
      backgroundColor: const Color(0xFFF7FAFF),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _SettingTile(
            icon: Icons.person_outline_rounded,
            title: '个人资料',
            subtitle: '昵称、头像、个性签名',
          ),
          SizedBox(height: 10),
          _SettingTile(
            icon: Icons.lock_outline_rounded,
            title: '账号与安全',
            subtitle: '密码、绑定手机与邮箱',
          ),
          SizedBox(height: 10),
          _SettingTile(
            icon: Icons.notifications_none_rounded,
            title: '通知设置',
            subtitle: '提醒频率与消息类型',
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: const Color(0xFF3F51B5)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8E98A8),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFFB3BCCB)),
        ],
      ),
    );
  }
}
