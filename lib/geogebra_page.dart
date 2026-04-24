import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GeogebraPage extends StatefulWidget {
  /// 可选的初始表达式（函数绘图模式），例如 "f(x) = x^2"
  final String? initialExpression;

  const GeogebraPage({super.key, this.initialExpression});

  @override
  State<GeogebraPage> createState() => _GeogebraPageState();
}

class _GeogebraPageState extends State<GeogebraPage> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isReady = false;
  bool _isDesktop = false;

  static const String _geogebraOnlineUrl =
      'https://www.geogebra.org/graphing';

  @override
  void initState() {
    super.initState();

    // 桌面端不支持 WebView，使用外部浏览器打开
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _isDesktop = true;
      _isLoading = false;
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..addJavaScriptChannel('FlutterChannel', onMessageReceived: _onJsMessage)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _onPageFinished();
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage = '资源加载失败: ${error.description}';
              });
            }
          },
        ),
      );

    _loadGeogebra();
  }

  Future<void> _loadGeogebra() async {
    try {
      final String htmlContent = await rootBundle.loadString(
        'assets/geogebra/index.html',
      );
      await _controller.loadHtmlString(htmlContent);
    } catch (e) {
      _controller.loadHtmlString(_fallbackHtml);
    }
  }

  Future<void> _openGeogebraOnline() async {
    final Uri uri = Uri.parse(_geogebraOnlineUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _onJsMessage(JavaScriptMessage message) {
    final String msg = message.message;
    if (msg == 'ready') {
      if (mounted) {
        setState(() {
          _isReady = true;
          _isLoading = false;
        });
      }
      if (widget.initialExpression != null) {
        _setExpression(widget.initialExpression!);
      }
    } else if (msg.startsWith('error:')) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = msg.substring(6);
        });
      }
    }
  }

  void _onPageFinished() {
    if (!_isReady && mounted) {
      Future.delayed(const Duration(seconds: 3), () {
        if (!_isReady && mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  String _escapeJsString(String s) {
    return s
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
  }

  Future<void> _setExpression(String expression) async {
    final String escaped = _escapeJsString(expression);
    await _controller.runJavaScript(
      'window.GeogebraBridge.setExpression("$escaped")',
    );
  }

  Future<void> _reset() async {
    await _controller.runJavaScript('window.GeogebraBridge.reset()');
  }

  Future<void> _retry() async {
    setState(() {
      _hasError = false;
      _isLoading = true;
      _errorMessage = '';
      _isReady = false;
    });
    await _loadGeogebra();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoGebra 数学工具'),
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
        actions: <Widget>[
          if (_isReady)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: '重置',
              onPressed: _reset,
            ),
        ],
      ),
      body: _isDesktop ? _buildDesktopBody() : _buildMobileBody(),
    );
  }

  Widget _buildDesktopBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.show_chart, size: 64, color: Color(0xFF3F51B5)),
            const SizedBox(height: 16),
            const Text(
              'GeoGebra 数学工具',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              '桌面端暂不支持内嵌 WebView\n请通过浏览器打开 GeoGebra 在线版',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _openGeogebraOnline,
              icon: const Icon(Icons.open_in_browser),
              label: const Text('在浏览器中打开 GeoGebra'),
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileBody() {
    return Stack(
      children: <Widget>[
        WebViewWidget(controller: _controller),

        if (_isLoading)
          Container(
            color: Colors.white,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'GeoGebra 加载中...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

        if (_hasError)
          Container(
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '加载失败',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage.isNotEmpty ? _errorMessage : '请检查网络连接后重试',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// 内置 fallback HTML（与 assets/geogebra/index.html 保持功能一致）
  String get _fallbackHtml {
    return '''
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>GeoGebra</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html, body { width: 100%; height: 100%; overflow: hidden; position: fixed; background: #ffffff; }
        #ggb-element { width: 100%; height: 100%; position: absolute; top: 0; left: 0; }
        #loading {
            position: absolute; top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            text-align: center; color: #666;
            font-family: sans-serif; z-index: 10;
        }
        .spinner {
            width: 40px; height: 40px; margin: 0 auto 12px;
            border: 4px solid #e0e0e0; border-top-color: #3F51B5;
            border-radius: 50%; animation: spin 0.8s linear infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
        #error {
            display: none;
            position: absolute; top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            text-align: center; color: #d32f2f;
            font-family: sans-serif; z-index: 10; padding: 20px;
        }
        #error button {
            margin-top: 12px; padding: 8px 24px;
            background: #3F51B5; color: #fff;
            border: none; border-radius: 6px;
            font-size: 14px; cursor: pointer;
        }
    </style>
</head>
<body>
    <div id="loading">
        <div class="spinner"></div>
        <span>GeoGebra 加载中...</span>
    </div>
    <div id="error">
        <p>GeoGebra 加载失败</p>
        <button onclick="location.reload()">重试</button>
    </div>
    <div id="ggb-element"></div>
    <script src="https://cdn.geogebra.org/apps/deployggb.js"></script>
    <script>
        window.GeogebraBridge = {
            _ready: false,
            _applet: null,
            onReady: function() {
                this._ready = true;
                if (window.FlutterChannel) {
                    window.FlutterChannel.postMessage('ready');
                }
            },
            onError: function(msg) {
                if (window.FlutterChannel) {
                    window.FlutterChannel.postMessage('error:' + msg);
                }
            },
            setExpression: function(expr) {
                if (this._applet) {
                    try { this._applet.setExpressionValue(expr); return true; }
                    catch(e) { return false; }
                }
                return false;
            },
            getPNG: function() {
                if (this._applet) {
                    try { return this._applet.getPNGBase64(1.0, true, 72); }
                    catch(e) { return null; }
                }
                return null;
            },
            reset: function() {
                if (this._applet) {
                    try { this._applet.reset(); return true; }
                    catch(e) { return false; }
                }
                return false;
            },
            setMode: function(mode) {
                if (this._applet) {
                    try { this._applet.setMode(mode); return true; }
                    catch(e) { return false; }
                }
                return false;
            }
        };
        var params = {
            "appName": "graphing", "width": "100%", "height": "100%",
            "showToolBar": true, "showAlgebraInput": true, "showMenuBar": true,
            "allowStyleBar": true, "enableLabelDrags": true, "enableShiftDragZoom": true,
            "enableRightClick": true, "showToolBarHelp": true, "showResetIcon": true,
            "appletOnLoad": function(api) {
                var loadingEl = document.getElementById('loading');
                if (loadingEl) loadingEl.style.display = 'none';
                window.GeogebraBridge._applet = api;
                window.GeogebraBridge.onReady();
            }
        };
        var applet = new GGBApplet(params, true);
        function initGeogebra() {
            try {
                applet.inject('ggb-element');
                setTimeout(function() {
                    if (!window.GeogebraBridge._ready) {
                        var loadingEl = document.getElementById('loading');
                        if (loadingEl) loadingEl.style.display = 'none';
                        var errEl = document.getElementById('error');
                        if (errEl) errEl.style.display = 'block';
                        if (window.FlutterChannel) {
                            window.FlutterChannel.postMessage('error:timeout');
                        }
                    }
                }, 30000);
            } catch(e) {
                document.getElementById('loading').style.display = 'none';
                document.getElementById('error').style.display = 'block';
                if (window.FlutterChannel) {
                    window.FlutterChannel.postMessage('error:' + e.message);
                }
            }
        }
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initGeogebra);
        } else {
            initGeogebra();
        }
    </script>
</body>
</html>
''';
  }
}
