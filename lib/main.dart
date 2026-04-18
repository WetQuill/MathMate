import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mathmate/beautiful_result_page.dart';
import 'package:mathmate/data/history_repository.dart';
import 'package:mathmate/history_list_page.dart';
import 'package:mathmate/profile_page.dart';
import 'package:mathmate/services/scanner_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HistoryRepository.instance.init();
  runApp(const MathMateApp());
}

class MathMateApp extends StatelessWidget {
  const MathMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3F51B5),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const <Widget>[
      QuestionHomePage(),
      NotesPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF3F51B5),
        unselectedItemColor: Colors.blueGrey.shade300,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: '题目',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border_rounded),
            label: '笔记',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

class QuestionHomePage extends StatefulWidget {
  const QuestionHomePage({super.key});

  @override
  State<QuestionHomePage> createState() => _QuestionHomePageState();
}

class _QuestionHomePageState extends State<QuestionHomePage> {
  final ScannerService _scannerService = ScannerService();

  bool _isScanning = false;
  String _scanStatus = '拍照难题';

  Future<void> _scanAndOpenResult() async {
    if (_isScanning) {
      return;
    }

    setState(() {
      _isScanning = true;
      _scanStatus = '正在扫描中...';
    });

    final File? scannedFile = await _scannerService.startScanning(context);

    if (!mounted) {
      return;
    }

    if (scannedFile == null) {
      setState(() {
        _isScanning = false;
        _scanStatus = '扫描已取消，点击重试';
      });
      return;
    }

    setState(() {
      _isScanning = false;
      _scanStatus = '拍照难题';
    });

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BeautifulResultPage(image: scannedFile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildSearchBar(),
              const SizedBox(height: 18),
              _buildCameraHero(),
              const SizedBox(height: 14),
              _buildToolboxCard(),
              const SizedBox(height: 16),
              const Text(
                '数学视频推荐',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              _buildVideoList(),
              const SizedBox(height: 18),
              _buildAssistantCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.search, color: Colors.blueGrey),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索题目或知识点',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: _scanAndOpenResult,
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryListPage()),
              );
            },
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 210,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CustomPaint(
                  size: const Size(double.infinity, 180),
                  painter: _FunctionWavePainter(),
                ),
                GestureDetector(
                  onTap: _scanAndOpenResult,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: <Color>[Color(0xFF4C6FFF), Color(0xFF3557E5)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFF4C6FFF).withValues(alpha: 0.35),
                          blurRadius: 26,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isScanning
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 42,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '拍照难题',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _scanStatus,
            style: TextStyle(color: Colors.blueGrey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildToolboxCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: <Widget>[
          Icon(Icons.work_outline_rounded, color: Color(0xFF3F51B5)),
          SizedBox(width: 10),
          Text(
            '数学工具箱',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    const List<_VideoCardData> videos = <_VideoCardData>[
      _VideoCardData(title: '图形解说', subtitle: '函数变化与图像'),
      _VideoCardData(title: '计算的基础', subtitle: '快速掌握通用套路'),
      _VideoCardData(title: '几何专题', subtitle: '角度与面积关系'),
    ];

    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          final _VideoCardData item = videos[index];
          return Container(
            width: 210,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFFE8EEFF), Color(0xFFDDE6FF)],
              ),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color(0xFF3F51B5),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssistantCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.smart_toy_outlined, color: Color(0xFF3F51B5)),
              ),
              const SizedBox(width: 10),
              const Text(
                '我是 MathMate AI 助手',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '示例题目：求数列的前n项和',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7FAFF),
      body: Center(
        child: Text(
          '笔记页（占位）',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _VideoCardData {
  final String title;
  final String subtitle;

  const _VideoCardData({required this.title, required this.subtitle});
}

class _FunctionWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color(0xFF9FB3FF).withValues(alpha: 0.5);

    final Path path1 = Path();
    final Path path2 = Path();

    for (double x = 0; x <= size.width; x += 1) {
      final double y1 = size.height * 0.58 + 18 * _sinLike(x / size.width * 6.28);
      final double y2 = size.height * 0.48 + 12 * _sinLike(x / size.width * 9.42 + 0.5);
      if (x == 0) {
        path1.moveTo(x, y1);
        path2.moveTo(x, y2);
      } else {
        path1.lineTo(x, y1);
        path2.lineTo(x, y2);
      }
    }

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint..color = const Color(0xFFB8C6FF).withValues(alpha: 0.4));
  }

  double _sinLike(double x) {
    return (x - x * x * x / 6 + x * x * x * x * x / 120).clamp(-1.0, 1.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
