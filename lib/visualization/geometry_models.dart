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

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      xMin: (json['xMin'] as num).toDouble(),
      xMax: (json['xMax'] as num).toDouble(),
      yMin: (json['yMin'] as num).toDouble(),
      yMax: (json['yMax'] as num).toDouble(),
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

  const GeometryElement({required this.id, required this.type, required this.raw});

  factory GeometryElement.fromJson(Map<String, dynamic> json) {
    return GeometryElement(
      id: json['id'] as String,
      type: json['type'] as String,
      raw: json,
    );
  }

  Map<String, dynamic> toJson() => raw;
}

class GeometryScene {
  final Viewport viewport;
  final List<GeometryElement> elements;

  const GeometryScene({required this.viewport, required this.elements});

  factory GeometryScene.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawElements = json['elements'] as List<dynamic>;
    return GeometryScene(
      viewport: Viewport.fromJson(json['viewport'] as Map<String, dynamic>),
      elements: rawElements
          .map((dynamic item) => GeometryElement.fromJson(item as Map<String, dynamic>))
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
