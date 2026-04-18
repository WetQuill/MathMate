import 'package:mathmate/visualization/safe_json_parser.dart';

class Viewport {
  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;

  const Viewport({
    required this.xMin,
    required this.xMax,
    required this.yMin,
    required this.yMax,
  });

  factory Viewport.fromJson(
    Map<String, dynamic> json, {
    required SafeJsonParser parser,
  }) {
    return Viewport(
      xMin: parser.safeToDouble(
        parser.readValueCaseInsensitive(json, <String>['xMin', 'xmin']),
        -5,
      ),
      xMax: parser.safeToDouble(
        parser.readValueCaseInsensitive(json, <String>['xMax', 'xmax']),
        5,
      ),
      yMin: parser.safeToDouble(
        parser.readValueCaseInsensitive(json, <String>['yMin', 'ymin']),
        -5,
      ),
      yMax: parser.safeToDouble(
        parser.readValueCaseInsensitive(json, <String>['yMax', 'ymax']),
        5,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'xMin': xMin,
      'xMax': xMax,
      'yMin': yMin,
      'yMax': yMax,
    };
  }
}

class GeometryElement {
  final String id;
  final String type;
  final Map<String, dynamic> raw;

  const GeometryElement({
    required this.id,
    required this.type,
    required this.raw,
  });

  factory GeometryElement.fromJson(
    Map<String, dynamic> json, {
    required SafeJsonParser parser,
  }) {
    final Map<String, dynamic> raw = parser.safeMap(json);
    final String type = parser.safeString(
      parser.readValueCaseInsensitive(raw, <String>['type']),
      'unknown',
    );
    final String id = parser.safeString(
      parser.readValueCaseInsensitive(raw, <String>['id']),
      'unknown',
    );

    _normalizeByType(raw, type, parser);

    return GeometryElement(
      id: id,
      type: type,
      raw: raw,
    );
  }

  static void _normalizeByType(
    Map<String, dynamic> raw,
    String type,
    SafeJsonParser parser,
  ) {
    if (raw.containsKey('offset')) {
      raw['offset'] = parser.safePoint(raw['offset']);
    }

    if (type == 'point') {
      raw['pos'] = parser.safePoint(
        parser.readValueCaseInsensitive(raw, <String>['pos']),
      );
      raw['label'] = parser.safeString(
        parser.readValueCaseInsensitive(raw, <String>['label']),
        raw['id']?.toString() ?? '',
      );
      return;
    }

    if (type == 'line') {
      raw['p1'] = parser.safeString(
        parser.readValueCaseInsensitive(raw, <String>['p1']),
      );
      raw['p2'] = parser.safeString(
        parser.readValueCaseInsensitive(raw, <String>['p2']),
      );
      return;
    }

    if (type == 'circle') {
      raw['center'] = parser.safePoint(
        parser.readValueCaseInsensitive(raw, <String>['center']),
      );
      raw['radius'] = parser.safeToDouble(
        parser.readValueCaseInsensitive(raw, <String>['radius']),
        1.0,
      );
      return;
    }

    if (type == 'dynamic_point') {
      raw['targetId'] = parser.safeString(
        parser.readValueCaseInsensitive(raw, <String>['targetId', 'targetid']),
      );
      raw['initialT'] = parser.safeToDouble(
        parser.readValueCaseInsensitive(raw, <String>['initialT', 'initialt']),
        0.25,
      );
      raw['pos'] = parser.safePoint(
        parser.readValueCaseInsensitive(raw, <String>['pos']),
      );
      raw['label'] = parser.safeString(
        parser.readValueCaseInsensitive(raw, <String>['label']),
        raw['id']?.toString() ?? '',
      );
    }
  }

  Map<String, dynamic> toJson() => raw;
}

class GeometryScene {
  final Viewport viewport;
  final List<GeometryElement> elements;

  const GeometryScene({required this.viewport, required this.elements});

  factory GeometryScene.fromJson(
    Map<String, dynamic> json, {
    required SafeJsonParser parser,
  }) {
    final Map<String, dynamic> safeJson = parser.safeMap(json);
    final Map<String, dynamic> viewportRaw = parser.safeMap(
      parser.readValueCaseInsensitive(
            safeJson,
            <String>['viewport'],
          ) ??
          <String, dynamic>{},
    );
    final List<dynamic> rawElements = parser.safeList(
      parser.readValueCaseInsensitive(
            safeJson,
            <String>['elements'],
          ) ??
          <dynamic>[],
    );
    return GeometryScene(
      viewport: Viewport.fromJson(
        viewportRaw,
        parser: parser,
      ),
      elements: rawElements
          .map(
            (dynamic item) => GeometryElement.fromJson(
              parser.safeMap(item),
              parser: parser,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'viewport': viewport.toJson(),
      'elements': elements.map((GeometryElement e) => e.toJson()).toList(),
    };
  }
}
