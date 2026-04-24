import 'dart:convert';

import 'package:mathmate/models/pipeline_models.dart';
import 'package:mathmate/services/prompts/visualization_prompt.dart';
import 'package:mathmate/services/volc_ai_client_service.dart';
import 'package:mathmate/visualization/geometry_validator.dart';
import 'package:mathmate/visualization/response_extractor.dart';

class VisualizationService {
  static const String _visualizationModelEnv = 'VOLC_VIS_MODEL_ID';

  final VolcAiClientService _client;

  VisualizationService({VolcAiClientService? client})
    : _client = client ?? VolcAiClientService();

  Future<VisualizeResult> buildGeometryScene({
    required String questionMarkdown,
    required String solutionMarkdown,
  }) async {
    final String userText =
        '题目(Markdown):\n$questionMarkdown\n\n解答(Markdown):\n$solutionMarkdown';

    final String raw = await _client.callTextPrompt(
      prompt: visualizationPrompt,
      userText: userText,
      modelEnv: _visualizationModelEnv,
    );

    final String? geometryText = ResponseExtractor.extractGeometryJsonText(raw);
    if (geometryText == null || geometryText.isEmpty) {
      return VisualizeResult(
        scene: null,
        rawOutput: raw,
        error: '未检测到 geometryjson 输出。',
      );
    }

    try {
      final dynamic decoded = jsonDecode(geometryText);
      if (decoded is! Map<String, dynamic>) {
        return VisualizeResult(
          scene: null,
          rawOutput: raw,
          error: 'geometryjson 根节点必须是对象。',
        );
      }

      final GeometryValidationResult validation = const GeometryValidator()
          .validate(decoded);
      if (!validation.isValid || validation.scene == null) {
        return VisualizeResult(
          scene: null,
          rawOutput: raw,
          error: validation.error ?? 'geometryjson 校验失败。',
        );
      }

      return VisualizeResult(scene: validation.scene!.toJson(), rawOutput: raw);
    } catch (e) {
      return VisualizeResult(
        scene: null,
        rawOutput: raw,
        error: 'geometryjson 解析失败: $e',
      );
    }
  }
}
