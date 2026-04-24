import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class VolcAiClientService {
  static const String _apiKeyEnv = 'VOLC_API_KEY';
  static const String _baseUrlEnv = 'VOLC_BASE_URL';
  static const String _defaultModelEnv = 'VOLC_MODEL_ID';
  static const String _requestFormatEnv = 'VOLC_REQUEST_FORMAT';
  static const String _defaultBaseUrl =
      'https://ark.cn-beijing.volces.com/api/v3/chat/completions';

  static bool _dotenvLoaded = false;

  Future<void> _ensureEnvLoaded() async {
    if (_dotenvLoaded) {
      return;
    }
    await dotenv.load(fileName: '.env');
    _dotenvLoaded = true;
  }

  Future<String> callVisionPrompt({
    required XFile imageFile,
    required String prompt,
    required String modelEnv,
  }) async {
    final List<int> bytes = await imageFile.readAsBytes();
    final String base64Image = base64Encode(bytes);

    return _request(
      modelEnv: modelEnv,
      messages: <Map<String, dynamic>>[
        <String, dynamic>{
          'role': 'user',
          'content': <Map<String, dynamic>>[
            <String, dynamic>{'type': 'text', 'text': prompt},
            <String, dynamic>{
              'type': 'image_url',
              'image_url': <String, String>{
                'url': 'data:image/jpeg;base64,$base64Image',
              },
            },
          ],
        },
      ],
    );
  }

  Future<String> callTextPrompt({
    required String prompt,
    required String userText,
    required String modelEnv,
  }) async {
    return _request(
      modelEnv: modelEnv,
      messages: <Map<String, String>>[
        <String, String>{'role': 'system', 'content': prompt},
        <String, String>{'role': 'user', 'content': userText},
      ],
    );
  }

  Future<String> _request({
    required String modelEnv,
    required List<Map<String, dynamic>> messages,
  }) async {
    await _ensureEnvLoaded();

    final String apiKey = (dotenv.env[_apiKeyEnv] ?? '').trim();
    final String modelId =
        (dotenv.env[modelEnv] ?? dotenv.env[_defaultModelEnv] ?? '').trim();
    final String baseUrl = (dotenv.env[_baseUrlEnv] ?? _defaultBaseUrl).trim();
    final String requestFormat = (dotenv.env[_requestFormatEnv] ?? 'auto')
        .trim()
        .toLowerCase();

    if (apiKey.isEmpty) {
      throw Exception('Missing env config: VOLC_API_KEY');
    }
    if (modelId.isEmpty) {
      throw Exception('Missing env config: $modelEnv or $_defaultModelEnv');
    }

    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    late http.Response response;
    if (requestFormat == 'messages') {
      response = await _postMessages(baseUrl, headers, modelId, messages);
    } else if (requestFormat == 'input') {
      response = await _postInput(baseUrl, headers, modelId, messages);
    } else {
      response = await _postMessages(baseUrl, headers, modelId, messages);
      final String detail = utf8.decode(response.bodyBytes);
      final String normalizedDetail = detail.toLowerCase();
      final bool unknownMessagesField =
          normalizedDetail.contains('messages') &&
          (normalizedDetail.contains('unknown field') ||
              normalizedDetail.contains('unknownfield'));
      if (response.statusCode != 200 && unknownMessagesField) {
        response = await _postInput(baseUrl, headers, modelId, messages);
      }
    }

    if (response.statusCode != 200) {
      final String detail = utf8.decode(response.bodyBytes);
      debugPrint('Volc API error($modelEnv): $detail');
      throw Exception('Volc API error($modelEnv): $detail');
    }

    final dynamic data = jsonDecode(utf8.decode(response.bodyBytes));
    final String parsed = _extractContentFromResponse(data).trim();
    if (parsed.isEmpty) {
      throw Exception('Volc API returned empty content ($modelEnv).');
    }
    return parsed;
  }

  Future<http.Response> _postMessages(
    String baseUrl,
    Map<String, String> headers,
    String modelId,
    List<Map<String, dynamic>> messages,
  ) {
    return http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'model': modelId,
        'messages': messages,
      }),
    );
  }

  Future<http.Response> _postInput(
    String baseUrl,
    Map<String, String> headers,
    String modelId,
    List<Map<String, dynamic>> messages,
  ) {
    return http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(<String, dynamic>{
        'model': modelId,
        'input': _toInputFormat(messages),
      }),
    );
  }

  List<Map<String, dynamic>> _toInputFormat(
    List<Map<String, dynamic>> messages,
  ) {
    return messages.map((Map<String, dynamic> message) {
      final String role = (message['role'] ?? 'user').toString();
      final dynamic content = message['content'];

      if (content is String) {
        return <String, dynamic>{
          'role': role,
          'content': <Map<String, String>>[
            <String, String>{'type': 'input_text', 'text': content},
          ],
        };
      }

      if (content is List) {
        final List<Map<String, dynamic>> mappedContent =
            <Map<String, dynamic>>[];
        for (final dynamic item in content) {
          if (item is! Map) {
            continue;
          }
          final dynamic type = item['type'];
          if (type == 'text') {
            mappedContent.add(<String, dynamic>{
              'type': 'input_text',
              'text': (item['text'] ?? '').toString(),
            });
          } else if (type == 'image_url') {
            final dynamic rawImageUrl = item['image_url'];
            String imageUrl = '';
            if (rawImageUrl is Map) {
              imageUrl = (rawImageUrl['url'] ?? '').toString();
            } else {
              imageUrl = (rawImageUrl ?? '').toString();
            }
            mappedContent.add(<String, dynamic>{
              'type': 'input_image',
              'image_url': imageUrl,
            });
          }
        }
        return <String, dynamic>{'role': role, 'content': mappedContent};
      }

      return <String, dynamic>{
        'role': role,
        'content': <Map<String, String>>[
          <String, String>{'type': 'input_text', 'text': content.toString()},
        ],
      };
    }).toList();
  }

  String _extractContentFromResponse(dynamic data) {
    final dynamic chatContent = data['choices']?[0]?['message']?['content'];
    final String fromChat = _extractContentAsText(chatContent).trim();
    if (fromChat.isNotEmpty) {
      return fromChat;
    }

    final dynamic outputText = data['output_text'];
    if (outputText is String && outputText.trim().isNotEmpty) {
      return outputText;
    }

    final dynamic output = data['output'];
    if (output is List) {
      final StringBuffer buffer = StringBuffer();
      for (final dynamic item in output) {
        if (item is! Map) {
          continue;
        }
        final dynamic content = item['content'];
        if (content is List) {
          for (final dynamic c in content) {
            if (c is! Map) {
              continue;
            }
            final dynamic text = c['text'];
            if (text is String && text.trim().isNotEmpty) {
              buffer.writeln(text);
            }
          }
        }
      }
      final String parsed = buffer.toString().trim();
      if (parsed.isNotEmpty) {
        return parsed;
      }
    }

    return '';
  }

  String _extractContentAsText(dynamic content) {
    if (content is String) {
      return content;
    }
    if (content is List) {
      final StringBuffer buffer = StringBuffer();
      for (final dynamic item in content) {
        if (item is Map && item['text'] is String) {
          buffer.writeln(item['text'] as String);
        }
      }
      return buffer.toString();
    }
    return '';
  }
}
