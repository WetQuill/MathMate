import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class VideoRecommendationService {
  static const String _apiUrl =
      'https://api-ai.vivo.com.cn/v1/chat/completions';
  static const String _apiKeyEnv = 'VIVO_API_KEY';
  static const String _modelEnv = 'VIVO_MODEL_ID';
  static const String _defaultModel = 'vivo-BlueLM-TB';

  static bool _dotenvLoaded = false;

  Future<void> _ensureEnvLoaded() async {
    if (_dotenvLoaded) {
      return;
    }
    await dotenv.load(fileName: '.env');
    _dotenvLoaded = true;
  }

  Future<List<String>> extractKeywords(String text) async {
    try {
      await _ensureEnvLoaded();
      final String apiKey = (dotenv.env[_apiKeyEnv] ?? '').trim();
      if (apiKey.isEmpty) {
        debugPrint('VideoRecommendationService: missing $_apiKeyEnv.');
        return <String>[];
      }

      final String model = (dotenv.env[_modelEnv] ?? _defaultModel).trim();
      final String prompt =
          '''
请从以下数学题目中提取关键词（数学概念、题型类别等），只返回关键词，用逗号分隔，最多返回5个关键词。

题目内容：
$text

关键词：''';

      final Map<String, dynamic> body = <String, dynamic>{
        'model': model,
        'messages': <Map<String, String>>[
          <String, String>{'role': 'user', 'content': prompt},
        ],
        'max_tokens': 100,
        'temperature': 0.3,
      };

      final http.Response response = await http
          .post(
            Uri.parse(_apiUrl),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String content = data['choices'][0]['message']['content'] ?? '';
        final List<String> keywords = content
            .split(RegExp(r'[,，、\n]'))
            .map((String s) => s.trim())
            .where((String s) => s.isNotEmpty)
            .take(5)
            .toList();
        return keywords;
      }
    } catch (e) {
      debugPrint('extractKeywords error: $e');
    }
    return <String>[];
  }
}
