import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Bilibili 视频播放页面
///
/// 移动端使用 WebView 内嵌播放；
/// 桌面端（Windows/Linux）使用外部浏览器打开。
class VideoPlayerPage extends StatefulWidget {
  final String title;
  final String bvId;

  const VideoPlayerPage({super.key, required this.title, required this.bvId});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isDesktop = false;

  @override
  void initState() {
    super.initState();

    // 桌面端不支持 WebView，直接用外部浏览器打开
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _isDesktop = true;
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openInExternalBrowser().then((_) {
          if (mounted) Navigator.pop(context);
        });
      });
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
        ),
      );

    _loadVideo();
  }

  void _loadVideo() {
    final String embedUrl =
        'https://player.bilibili.com/player.html?bvid=${widget.bvId}'
        '&autoplay=1'
        '&muted=false'
        '&high_quality=1'
        '&danmaku=1';

    _controller.loadRequest(Uri.parse(embedUrl));
  }

  Uri get _bilibiliPageUri =>
      Uri.parse('https://www.bilibili.com/video/${widget.bvId}/');

  Uri get _bilibiliAppUri => Uri.parse('bilibili://video/${widget.bvId}');

  Future<void> _openInExternalBrowser() async {
    final Uri appUri = _bilibiliAppUri;
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
      return;
    }
    final Uri webUri = _bilibiliPageUri;
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _retry() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 15),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _isDesktop ? _buildDesktopBody() : _buildMobileBody(),
    );
  }

  Widget _buildDesktopBody() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.open_in_browser, size: 48, color: Colors.white54),
          const SizedBox(height: 16),
          const Text(
            '正在外部浏览器中打开...',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: const TextStyle(color: Colors.white38, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _openInExternalBrowser,
            icon: const Icon(Icons.open_in_new),
            label: const Text('重新打开'),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBody() {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: WebViewWidget(controller: _controller),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.black,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'BV: ${widget.bvId}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Text(
                          '视频来源: Bilibili',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _openInExternalBrowser,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.open_in_new,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '在 B站 打开',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // 加载指示器
        if (_isLoading)
          const Positioned(
            top: 0, left: 0, right: 0,
            child: LinearProgressIndicator(backgroundColor: Colors.transparent),
          ),

        // 错误状态
        if (_hasError)
          Container(
            color: Colors.black87,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.error_outline, color: Colors.white54, size: 48),
                  const SizedBox(height: 16),
                  const Text('视频加载失败',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('可能是网络问题或 B站 播放器限制',
                      style: TextStyle(color: Colors.white38, fontSize: 12)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FilledButton.icon(
                        onPressed: _retry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('重试'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _openInExternalBrowser,
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('在 B站 打开'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
