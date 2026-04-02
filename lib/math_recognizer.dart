import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MathRecognizer {
  static const _apiKeyEnv = 'VOLC_API_KEY';
  static const _modelIdEnv = 'VOLC_MODEL_ID';
  static const _baseUrlEnv = 'VOLC_BASE_URL';
  static const _defaultBaseUrl =
      'https://ark.cn-beijing.volces.com/api/v3/chat/completions';

  static bool _dotenvLoaded = false;

  Future<void> _ensureEnvLoaded() async {
    if (_dotenvLoaded) return;
    await dotenv.load(fileName: '.env');
    _dotenvLoaded = true;
  }

  Future<String?> recognizeFromImage(XFile imageFile) async {
    try {
      await _ensureEnvLoaded();

      final apiKey = (dotenv.env[_apiKeyEnv] ?? '').trim();
      final modelId = (dotenv.env[_modelIdEnv] ?? '').trim();
      final baseUrl = (dotenv.env[_baseUrlEnv] ?? _defaultBaseUrl).trim();

      if (apiKey.isEmpty || modelId.isEmpty) {
        return 'Missing env config: VOLC_API_KEY / VOLC_MODEL_ID';
      }

      final bytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": modelId,
          "messages": [
            {
              "role": "user",
              "content": [
                {
                  "type": "text",
                  "text":
                      "你是专业的数学题目识别工具，严格遵守以下规则：\n"
                      "1. 只做图像文字与公式识别，绝对不解题、不解析、不计算、不生成答案。\n"
                      "2. 完整识别题干内容，包括中文、数字、符号、数学公式。\n"
                      "3. 输出格式严格为：\n"
                      "   - 所有纯文字题干部分，单独占多行（每个小问换行）\n"
                      "   - 所有数学公式部分，单独占一行，用标准LaTeX语法，不要用任何包裹符号\n"
                      "4. 文字和公式必须完全分离，文字行里绝对不能包含任何公式，公式行里绝对不能包含任何文字。\n"
                      "5. 多个小问（1）（2）（3）或①②③，每个小问单独换行。\n"
                      "6. 只输出识别结果，不输出任何多余解释、开头、结尾、说明。",
                },
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        String result = data['choices'][0]['message']['content'];

        result = result.replaceAll('```latex', '').replaceAll('```', '');
        result = result.replaceAll('\\(', '').replaceAll('\\)', '');
        result = result.replaceAll('\\[', '').replaceAll('\\]', '');
        result = result.replaceAll('\$', '');
        result = result.trim();

        return result;
      } else {
        final errorDetail = utf8.decode(response.bodyBytes);
        debugPrint('Volc API error: $errorDetail');
        return "接口报错: $errorDetail";
      }
    } catch (e) {
      debugPrint('识别错误: $e');
      return "识别出错: $e";
    }
  }
}
