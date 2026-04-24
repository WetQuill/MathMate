class SafeJsonParser {
  const SafeJsonParser();

  double safeToDouble(dynamic value, [double defaultValue = 0.0]) {
    return _safeToDouble(value, defaultValue);
  }

  double _safeToDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value == null) {
      return defaultValue;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      final double? parsed = double.tryParse(value.trim());
      return parsed ?? defaultValue;
    }
    return defaultValue;
  }

  String safeString(dynamic value, [String defaultValue = '']) {
    if (value == null) {
      return defaultValue;
    }
    if (value is String) {
      final String trimmed = value.trim();
      return trimmed.isEmpty ? defaultValue : trimmed;
    }
    return value.toString();
  }

  Map<String, dynamic> safeMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }
    if (value is Map) {
      return value.map(
        (dynamic key, dynamic mapValue) =>
            MapEntry<String, dynamic>(key.toString(), mapValue),
      );
    }
    return <String, dynamic>{};
  }

  List<dynamic> safeList(dynamic value) {
    if (value is List<dynamic>) {
      return List<dynamic>.from(value);
    }
    if (value is List) {
      return List<dynamic>.from(value);
    }
    return <dynamic>[];
  }

  List<double> safePoint(
    dynamic value, {
    List<double> defaultValue = const <double>[0.0, 0.0],
  }) {
    final List<dynamic> list = safeList(value);
    if (list.length >= 2) {
      return <double>[
        _safeToDouble(list[0], defaultValue[0]),
        _safeToDouble(list[1], defaultValue[1]),
      ];
    }

    final Map<String, dynamic> map = safeMap(value);
    if (map.isNotEmpty) {
      return <double>[
        _safeToDouble(map['x'], defaultValue[0]),
        _safeToDouble(map['y'], defaultValue[1]),
      ];
    }

    return List<double>.from(defaultValue);
  }

  dynamic readValueCaseInsensitive(
    Map<String, dynamic> map,
    List<String> candidateKeys,
  ) {
    if (map.isEmpty || candidateKeys.isEmpty) {
      return null;
    }

    for (final String key in candidateKeys) {
      if (map.containsKey(key)) {
        return map[key];
      }
    }

    final Map<String, dynamic> lowered = <String, dynamic>{};
    for (final MapEntry<String, dynamic> entry in map.entries) {
      lowered[entry.key.toLowerCase()] = entry.value;
    }

    for (final String key in candidateKeys) {
      final String normalized = key.toLowerCase();
      if (lowered.containsKey(normalized)) {
        return lowered[normalized];
      }
    }

    return null;
  }
}
