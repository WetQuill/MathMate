import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VisualizationController {
  WebViewController? _webViewController;
  bool _isReady = false;

  void attach(WebViewController controller) {
    _webViewController = controller;
  }

  void setReady(bool value) {
    _isReady = value;
  }

  Future<void> loadScene(Map<String, dynamic> sceneJson) async {
    if (_webViewController == null || !_isReady) {
      return;
    }

    try {
      final String payload = jsonEncode(sceneJson);
      await _webViewController!.runJavaScript('window.renderScene($payload);');
    } catch (e) {
      debugPrint('VisualizationController loadScene error: $e');
    }
  }
}
