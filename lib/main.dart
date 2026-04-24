import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mathmate/beautiful_result_page.dart';
import 'package:mathmate/pages/chat_home_page.dart';
import 'package:mathmate/geogebra_page.dart';
import 'package:mathmate/data/conversation_repository.dart';
import 'package:mathmate/data/history_repository.dart';
import 'package:mathmate/data/video_recommendations.dart';
import 'package:mathmate/grade_selection_page.dart';
import 'package:mathmate/history_list_page.dart';
import 'package:mathmate/pages/video_player_page.dart';
import 'package:mathmate/profile_page.dart';
import 'package:mathmate/services/scanner_service.dart';
import 'package:mathmate/services/video_recommendation_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HistoryRepository.instance.init();
  await ConversationRepository.instance.init();

  final bool isFirst = await HistoryRepository.instance.isFirstLaunch();
  runApp(MathMateApp(checkFirstLaunch: isFirst));
}

class MathMateApp extends StatelessWidget {
  final bool checkFirstLaunch;

  const MathMateApp({super.key, required this.checkFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3F51B5),
      ),
      home: checkFirstLaunch ? const GradeSelectionPage() : const MainScreen(),
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
    _pages = const <Widget>[QuestionHomePage(), NotesPage(), ProfilePage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
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
  final VideoRecommendationService _recommendationService =
      VideoRecommendationService();
  final TextEditingController _searchController = TextEditingController();

  bool _isScanning = false;
  String _scanStatus = '拍照难题';
  bool _isRefreshing = false;
  List<VideoInfo> _recommendedVideos = <VideoInfo>[];

  @override
  void initState() {
    super.initState();
    _loadGradeLevelAndVideos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSearchChat() {
    final String query = _searchController.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatHomePage(
          initialQuery: query.isNotEmpty ? query : null,
        ),
      ),
    );
  }

  Future<void> _loadGradeLevelAndVideos() async {
    final int? grade = await HistoryRepository.instance.getGradeLevel();
    if (mounted) {
      setState(() {
        _recommendedVideos = getVideosByGrade(grade);
      });
    }
  }

  Future<void> _onRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      // 模拟网络请求延迟，确保有足够的时间显示刷新动画
      await Future<void>.delayed(const Duration(milliseconds: 500));
      
      final List<String> keywords = await _recommendationService
          .extractKeywords('函数 椭圆 几何');
      if (keywords.isNotEmpty) {
        final List<VideoInfo> matched = getVideosByKeywords(keywords);
        if (matched.isNotEmpty) {
          setState(() {
            _recommendedVideos = matched;
          });
        } else {
          // 没有匹配的视频
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('暂无相关视频推荐'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } else {
        // 关键词提取失败
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('无法获取推荐关键词'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      // 网络请求失败
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('网络请求失败: ${e.toString()}'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: '重试',
              onPressed: _onRefresh,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

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
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: const Color(0xFF3F51B5),
          backgroundColor: Colors.white,
          displacement: 40.0,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      '数学视频推荐',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (_isRefreshing)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildVideoList(),
              ],
            ),
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
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: '搜索题目或问蓝心助手...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _openSearchChat(),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(
                      builder: (_) => const ChatHomePage(),
                    ));
            },
            icon: const Icon(Icons.chat_bubble_outline_rounded),
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
                          color: const Color(
                            0xFF4C6FFF,
                          ).withValues(alpha: 0.35),
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
          Text(_scanStatus, style: TextStyle(color: Colors.blueGrey.shade600)),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(Icons.work_outline_rounded, color: Color(0xFF3F51B5)),
              SizedBox(width: 10),
              Text(
                '数学工具箱',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              final List<Map<String, dynamic>> tools = <Map<String, dynamic>>[
                <String, dynamic>{
                  'icon': Icons.calculate_outlined,
                  'name': '计算器',
                  'onTap': () {},
                },
                <String, dynamic>{
                  'icon': Icons.show_chart,
                  'name': '几何画板',
                  'onTap': () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const GeogebraPage()),
                    );
                  },
                },
                <String, dynamic>{
                  'icon': Icons.functions_outlined,
                  'name': '函数绘图',
                  'onTap': () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const GeogebraPage(initialExpression: 'f(x) = x^2'),
                      ),
                    );
                  },
                },
              ];

              final Map<String, dynamic> tool = tools[index];
              return GestureDetector(
                onTap: tool['onTap'] as VoidCallback,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        tool['icon'] as IconData,
                        color: const Color(0xFF3F51B5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tool['name'] as String,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVideoList() {
    final List<VideoInfo> videos = _recommendedVideos;

    if (videos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Text('下拉刷新获取推荐视频', style: TextStyle(color: Colors.grey)),
      );
    }

    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: 10),
        itemBuilder: (BuildContext context, int index) {
          final VideoInfo item = videos[index];
          return _VideoCard(video: item);
        },
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
      final double y1 =
          size.height * 0.58 + 18 * _sinLike(x / size.width * 6.28);
      final double y2 =
          size.height * 0.48 + 12 * _sinLike(x / size.width * 9.42 + 0.5);
      if (x == 0) {
        path1.moveTo(x, y1);
        path2.moveTo(x, y2);
      } else {
        path1.lineTo(x, y1);
        path2.lineTo(x, y2);
      }
    }

    canvas.drawPath(path1, paint);
    canvas.drawPath(
      path2,
      paint..color = const Color(0xFFB8C6FF).withValues(alpha: 0.4),
    );
  }

  double _sinLike(double x) {
    return (x - x * x * x / 6 + x * x * x * x * x / 120).clamp(-1.0, 1.0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _VideoCard extends StatefulWidget {
  final VideoInfo video;

  const _VideoCard({required this.video});

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> {
  String? _coverUrl;

  @override
  void initState() {
    super.initState();
    _loadCover();
  }

  Future<void> _loadCover() async {
    final String url = await widget.video.getCoverUrl();
    if (mounted) {
      setState(() {
        _coverUrl = url;
      });
    }
  }

  void _openVideo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            VideoPlayerPage(title: widget.video.title, bvId: widget.video.bvId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openVideo,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              if (_coverUrl != null && _coverUrl!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: _coverUrl!,
                  fit: BoxFit.cover,
                  placeholder: (BuildContext context, String url) =>
                      Container(color: Colors.grey[200]),
                  errorWidget:
                      (BuildContext context, String url, Object error) =>
                          Container(
                            color: const Color(0xFFE8EEFF),
                            child: const Icon(
                              Icons.video_library,
                              color: Color(0xFF3F51B5),
                              size: 40,
                            ),
                          ),
                )
              else
                Container(
                  color: const Color(0xFFE8EEFF),
                  child: const Icon(
                    Icons.video_library,
                    color: Color(0xFF3F51B5),
                    size: 40,
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.transparent, Colors.black54],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        widget.video.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.video.subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.play_arrow,
                    color: Color(0xFF3F51B5),
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
