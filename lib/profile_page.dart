import 'package:flutter/material.dart';
import 'package:mathmate/about_mathmate_page.dart';
import 'package:mathmate/account_settings_page.dart';
import 'package:mathmate/grade_selection_page.dart';
import 'package:mathmate/help_support_page.dart';
import 'package:mathmate/history_list_page.dart';

const Color _profilePrimaryColor = Color(0xFF3F51B5);
const Color _profileBackgroundColor = Colors.white;
const Color _profileMutedTextColor = Color(0xFF8E98A8);
const Color _profileTopDecorColor = Color(0xFFF4F6FA);
const Color _profileCardShadowColor = Color(0x12000000);
const double _profileCardRadius = 12;
const double _profileCardElevationBlur = 10;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _profileBackgroundColor,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -70,
            left: 0,
            right: 0,
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                color: _profileTopDecorColor,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(320, 120),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    '我的',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 22),
                  _buildHeader(),
                  const SizedBox(height: 26),
                  _MenuCard(
                    icon: Icons.settings_outlined,
                    title: '账户设置',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AccountSettingsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.school_outlined,
                    title: '更换年级',
                    onTap: () async {
                      final int? result = await Navigator.of(context).push<int>(
                        MaterialPageRoute(
                          builder: (_) =>
                              const GradeSelectionPage(isFromSettings: true),
                        ),
                      );
                      if (result != null && mounted) {
                        setState(() {});
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.query_stats_rounded,
                    title: '历史记录',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const HistoryListPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.help_outline_rounded,
                    title: '帮助与支持',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const HelpSupportPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _MenuCard(
                    icon: Icons.info_outline_rounded,
                    title: '关于 MathMate',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AboutMathMatePage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Material(
                    color: const Color(0xFFF2F4F8),
                    borderRadius: BorderRadius.circular(_profileCardRadius),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(_profileCardRadius),
                      onTap: () {},
                      child: const SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Center(
                          child: Text(
                            '退出登录',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5D6778),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFF556EEA), Color(0xFF3F51B5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: _profilePrimaryColor.withValues(alpha: 0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'M+',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'MathMate_User',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Level: Math Explorer',
            style: TextStyle(fontSize: 13, color: _profileMutedTextColor),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_profileCardRadius),
      shadowColor: _profileCardShadowColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(_profileCardRadius),
        onTap: onTap,
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_profileCardRadius),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: _profileCardShadowColor,
                blurRadius: _profileCardElevationBlur,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, color: _profilePrimaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFFB3BCCB)),
            ],
          ),
        ),
      ),
    );
  }
}
