import 'dart:convert';

class ExtractedResponse {
  final String cleanFormulaText;
  final String? geometryJsonText;

  const ExtractedResponse({
    required this.cleanFormulaText,
    this.geometryJsonText,
  });
}

class ResponseExtractor {
  static final RegExp _blockPattern = RegExp(
    r'```(?:geometryjson|json)\s*([\s\S]*?)```',
    caseSensitive: false,
  );

  static ExtractedResponse split(String fullResponse) {
    final String? geometryJsonText = extractGeometryJsonText(fullResponse);
    if (geometryJsonText == null) {
      return ExtractedResponse(cleanFormulaText: fullResponse.trim());
    }

    final String cleaned = removeGeometryJsonBlock(fullResponse);
    return ExtractedResponse(
      cleanFormulaText: cleaned,
      geometryJsonText: geometryJsonText,
    );
  }

  static String removeGeometryJsonBlock(String fullResponse) {
    final Iterable<RegExpMatch> matches = _blockPattern.allMatches(
      fullResponse,
    );

    for (final RegExpMatch match in matches) {
      final String blockContent = (match.group(1) ?? '').trim();
      if (!_isGeometryJson(blockContent)) {
        continue;
      }

      final String matchedText = match.group(0) ?? '';
      return fullResponse.replaceFirst(matchedText, '').trim();
    }

    if (_isGeometryJson(fullResponse.trim())) {
      return '';
    }

    return fullResponse.trim();
  }

  static String? extractGeometryJsonText(String fullResponse) {
    final Iterable<RegExpMatch> matches = _blockPattern.allMatches(
      fullResponse,
    );

    for (final RegExpMatch match in matches) {
      final String blockContent = (match.group(1) ?? '').trim();
      if (!_isGeometryJson(blockContent)) {
        continue;
      }

      return blockContent;
    }

    if (_isGeometryJson(fullResponse.trim())) {
      return fullResponse.trim();
    }

    return null;
  }

  static bool _isGeometryJson(String text) {
    try {
      final dynamic decoded = jsonDecode(text);
      if (decoded is! Map<String, dynamic>) {
        return false;
      }
      return decoded.containsKey('viewport') && decoded.containsKey('elements');
    } catch (_) {
      return false;
    }
  }
}
