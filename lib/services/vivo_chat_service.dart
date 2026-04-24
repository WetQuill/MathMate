import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class VivoChatMessage {
  final String role;
  final String content;

  VivoChatMessage({required this.role, required this.content});

  Map<String, String> toMap() => <String, String>{
    'role': role,
    'content': content,
  };
}

class VivoAiChatService {
  static const String _apiKeyEnv = 'VIVO_API_KEY';
  static const String _modelEnv = 'VIVO_MODEL_ID';
  static const String _baseUrl =
      'https://api-ai.vivo.com.cn/v1/chat/completions';

  static bool _dotenvLoaded = false;

  Future<void> _ensureEnvLoaded() async {
    if (_dotenvLoaded) return;
    await dotenv.load(fileName: '.env');
    _dotenvLoaded = true;
  }

  Future<String> sendMessage(List<VivoChatMessage> messages) async {
    await _ensureEnvLoaded();

    final String apiKey = (dotenv.env[_apiKeyEnv] ?? '').trim();
    final String modelId = (dotenv.env[_modelEnv] ?? 'Volc-DeepSeek-V3.2')
        .trim();

    if (apiKey.isEmpty) {
      throw Exception('Missing env config: VIVO_API_KEY');
    }

    final List<Map<String, String>> formattedMessages = messages
        .map((m) => m.toMap())
        .toList();

    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer $apiKey',
    };

    final Map<String, dynamic> body = <String, dynamic>{
      'model': modelId,
      'messages': formattedMessages,
      'temperature': 0.7,
      'max_tokens': 2048,
    };

    final http.Response response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      final String detail = utf8.decode(response.bodyBytes);
      debugPrint('Vivo API error: $detail');
      throw Exception('Vivo API error: $detail');
    }

    final dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
    return _extractContent(data);
  }

  String _extractContent(dynamic data) {
    final dynamic content = data['choices']?[0]?['message']?['content'];
    if (content is String) {
      return content.trim();
    }
    return '';
  }
}
