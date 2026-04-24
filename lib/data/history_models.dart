import 'package:isar/isar.dart';
import 'package:mathmate/visualization/safe_json_parser.dart';

part 'history_models.g.dart';

@collection
class MathHistory {
  Id id = Isar.autoIncrement;

  late DateTime timestamp;
  late String originalImagePath;
  late String ocrContent;
  late String solutionMarkdown;
  late String latexResult;

  GeometrySceneEmbedded? geometryScene;
}

@embedded
class GeometrySceneEmbedded {
  ViewportEmbedded? viewport;
  List<GeometryElementEmbedded> elements = <GeometryElementEmbedded>[];

  static GeometrySceneEmbedded fromMap(
    Map<String, dynamic> map,
    SafeJsonParser parser,
  ) {
    final GeometrySceneEmbedded scene = GeometrySceneEmbedded();
    scene.viewport = ViewportEmbedded.fromMap(
      parser.safeMap(
        parser.readValueCaseInsensitive(map, <String>['viewport']) ??
            <String, dynamic>{},
      ),
      parser,
    );

    final List<dynamic> rawElements = parser.safeList(
      parser.readValueCaseInsensitive(map, <String>['elements']) ?? <dynamic>[],
    );
    scene.elements = rawElements
        .map(
          (dynamic item) =>
              GeometryElementEmbedded.fromMap(parser.safeMap(item), parser),
        )
        .toList();

    return scene;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'viewport':
          viewport?.toMap() ??
          <String, dynamic>{
            'xMin': -5.0,
            'xMax': 5.0,
            'yMin': -5.0,
            'yMax': 5.0,
          },
      'elements': elements
          .map((GeometryElementEmbedded e) => e.toMap())
          .toList(),
    };
  }
}

@embedded
class ViewportEmbedded {
  double xMin = -5.0;
  double xMax = 5.0;
  double yMin = -5.0;
  double yMax = 5.0;

  static ViewportEmbedded fromMap(
    Map<String, dynamic> map,
    SafeJsonParser parser,
  ) {
    final ViewportEmbedded viewport = ViewportEmbedded();
    viewport.xMin = parser.safeToDouble(
      parser.readValueCaseInsensitive(map, <String>['xMin', 'xmin']),
      -5.0,
    );
    viewport.xMax = parser.safeToDouble(
      parser.readValueCaseInsensitive(map, <String>['xMax', 'xmax']),
      5.0,
    );
    viewport.yMin = parser.safeToDouble(
      parser.readValueCaseInsensitive(map, <String>['yMin', 'ymin']),
      -5.0,
    );
    viewport.yMax = parser.safeToDouble(
      parser.readValueCaseInsensitive(map, <String>['yMax', 'ymax']),
      5.0,
    );
    return viewport;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'xMin': xMin,
      'xMax': xMax,
      'yMin': yMin,
      'yMax': yMax,
    };
  }
}

@embedded
class GeometryElementEmbedded {
  String id = '';
  String type = '';
  String label = '';

  String p1 = '';
  String p2 = '';
  String targetId = '';
  String constraint = '';
  String style = '';

  bool visible = true;

  double initialT = 0.25;
  double radius = 1.0;

  double posX = 0.0;
  double posY = 0.0;
  double centerX = 0.0;
  double centerY = 0.0;
  double offsetX = 0.0;
  double offsetY = 0.0;

  static GeometryElementEmbedded fromMap(
    Map<String, dynamic> map,
    SafeJsonParser parser,
  ) {
    final GeometryElementEmbedded element = GeometryElementEmbedded();

    element.id = parser.safeString(
      parser.readValueCaseInsensitive(map, <String>['id']),
    );
    element.type = parser.safeString(
      parser.readValueCaseInsensitive(map, <String>['type']),
    );
    element.label = parser.safeString(
      parser.readValueCaseInsensitive(map, <String>['label']),
    );

    element.p1 = parser.safeString(
      parser.readValueCaseInsensitive(map, <String>['p1']),
    );
    element.p2 = parser.safeString(
      parser.readValueCaseInsensitive(map, <String>['p2']),
    );
    element.targetId = parser.safeString(
      parser.readValueCaseInsensitive(map, <String>['targetId', 'targetid']),
    );
    element.constraint = parser.safeString(
      parser.readValueCaseInsensitive(map, <String>['constraint']),
    );
    element.style = parser.safeString(
      parser.readValueCaseInsensitive(map, <String>['style']),
    );

    final dynamic visibleRaw = parser.readValueCaseInsensitive(map, <String>[
      'visible',
    ]);
    element.visible = visibleRaw is bool ? visibleRaw : true;

    element.initialT = parser.safeToDouble(
      parser.readValueCaseInsensitive(map, <String>['initialT', 'initialt']),
      0.25,
    );
    element.radius = parser.safeToDouble(
      parser.readValueCaseInsensitive(map, <String>['radius']),
      1.0,
    );

    final List<double> pos = parser.safePoint(
      parser.readValueCaseInsensitive(map, <String>['pos']),
    );
    element.posX = parser.safeToDouble(pos[0], 0.0);
    element.posY = parser.safeToDouble(pos[1], 0.0);

    final List<double> center = parser.safePoint(
      parser.readValueCaseInsensitive(map, <String>['center']),
    );
    element.centerX = parser.safeToDouble(center[0], 0.0);
    element.centerY = parser.safeToDouble(center[1], 0.0);

    final List<double> offset = parser.safePoint(
      parser.readValueCaseInsensitive(map, <String>['offset']),
    );
    element.offsetX = parser.safeToDouble(offset[0], 0.0);
    element.offsetY = parser.safeToDouble(offset[1], 0.0);

    return element;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'id': id,
      'type': type,
      'visible': visible,
    };

    if (label.isNotEmpty) {
      map['label'] = label;
    }
    if (p1.isNotEmpty) {
      map['p1'] = p1;
    }
    if (p2.isNotEmpty) {
      map['p2'] = p2;
    }
    if (targetId.isNotEmpty) {
      map['targetId'] = targetId;
    }
    if (constraint.isNotEmpty) {
      map['constraint'] = constraint;
    }
    if (style.isNotEmpty) {
      map['style'] = style;
    }

    if (type == 'point' || type == 'dynamic_point') {
      map['pos'] = <double>[posX, posY];
    }
    if (type == 'circle') {
      map['center'] = <double>[centerX, centerY];
      map['radius'] = radius;
    }
    if (type == 'dynamic_point') {
      map['initialT'] = initialT;
      map['offset'] = <double>[offsetX, offsetY];
    }

    return map;
  }
}
