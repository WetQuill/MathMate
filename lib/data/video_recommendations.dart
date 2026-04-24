import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoInfo {
  final String title;
  final String subtitle;
  final String bvId;
  final List<String> keywords;
  String? _coverUrl;

  VideoInfo({
    required this.title,
    required this.subtitle,
    required this.bvId,
    required this.keywords,
  });

  Future<String> getCoverUrl() async {
    if (_coverUrl != null) return _coverUrl!;

    try {
      final String apiUrl =
          'https://api.bilibili.com/x/web-interface/view?bvid=$bvId';
      final http.Response response = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['code'] == 0 && data['data'] != null) {
          _coverUrl = data['data']['pic'] as String?;
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('Failed to fetch cover for $bvId: $e');
    }

    return _coverUrl ?? '';
  }
}

final List<VideoInfo> allVideos = <VideoInfo>[
  // 小学
  VideoInfo(
    title: '小学数学基础',
    subtitle: '夯实基础很重要',
    bvId: 'BV12A9cBmExK',
    keywords: <String>['小学', '基础', '计算', '加减乘除'],
  ),
  VideoInfo(
    title: '小学奥数思维',
    subtitle: '拓展数学思维',
    bvId: 'BV1p1rQYbEYb',
    keywords: <String>['小学', '奥数', '思维', '拓展'],
  ),

  // 初中
  VideoInfo(
    title: '初中数学几何',
    subtitle: '几何证明与计算',
    bvId: 'BV17T4y1E7Kt',
    keywords: <String>['初中', '几何', '证明', '三角形', '全等', '相似'],
  ),
  VideoInfo(
    title: '初中代数专题',
    subtitle: '方程与函数',
    bvId: 'BV1gJ411v78Z',
    keywords: <String>['初中', '代数', '方程', '函数', '一次函数', '二次函数'],
  ),

  // 高中
  VideoInfo(
    title: '高中数学函数',
    subtitle: '函数与导数',
    bvId: 'BV1w94y157Ti',
    keywords: <String>['高中', '函数', '导数', '单调性', '极值'],
  ),
  VideoInfo(
    title: '高中解析几何',
    subtitle: '圆锥曲线专题',
    bvId: 'BV1d8qaBkEVJ',
    keywords: <String>['高中', '解析几何', '椭圆', '双曲线', '抛物线', '圆锥曲线'],
  ),
  VideoInfo(
    title: '高中概率统计',
    subtitle: '概率与分布',
    bvId: 'BV1Me411P7tx',
    keywords: <String>['高中', '概率', '统计', '分布', '随机变量'],
  ),

  // 圆锥曲线专题（用户提供）
  VideoInfo(
    title: '圆锥曲线综合',
    subtitle: '椭圆双曲线抛物线',
    bvId: 'BV1K7q5YEEAR',
    keywords: <String>['圆锥曲线', '椭圆', '双曲线', '抛物线', '离心率', '焦点'],
  ),
];

// 获取三个学段各一个代表视频（用于未选择年级时）
VideoInfo _getPrimaryVideoByStage(String stage) {
  for (final VideoInfo video in allVideos) {
    if (video.keywords.contains(stage)) {
      return video;
    }
  }
  return allVideos.first;
}

List<VideoInfo> getVideosByGrade(int? grade) {
  if (grade == null) {
    // 未选择年级时，返回三个学段各一个视频
    return <VideoInfo>[
      _getPrimaryVideoByStage('高中'),
      _getPrimaryVideoByStage('初中'),
      _getPrimaryVideoByStage('小学'),
    ];
  }

  if (grade >= 1 && grade <= 6) {
    return allVideos.where((v) => v.keywords.contains('小学')).toList();
  } else if (grade >= 7 && grade <= 9) {
    return allVideos.where((v) => v.keywords.contains('初中')).toList();
  } else if (grade >= 10 && grade <= 12) {
    return allVideos.where((v) => v.keywords.contains('高中')).toList();
  }
  return <VideoInfo>[];
}

List<VideoInfo> getVideosByKeywords(List<String> keywords) {
  if (keywords.isEmpty) return <VideoInfo>[];

  final List<VideoInfo> matched = <VideoInfo>[];
  for (final VideoInfo video in allVideos) {
    for (final String keyword in keywords) {
      if (video.keywords.any(
        (k) => k.toLowerCase().contains(keyword.toLowerCase()),
      )) {
        matched.add(video);
        break;
      }
    }
  }
  return matched;
}
