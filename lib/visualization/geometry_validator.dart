import 'package:mathmate/visualization/geometry_models.dart';

class GeometryValidationResult {
  final bool isValid;
  final String? error;
  final GeometryScene? scene;

  const GeometryValidationResult({
    required this.isValid,
    this.error,
    this.scene,
  });
}

class GeometryValidator {
  const GeometryValidator();

  GeometryValidationResult validate(Map<String, dynamic> json) {
    try {
      if (!json.containsKey('viewport') || !json.containsKey('elements')) {
        return const GeometryValidationResult(
          isValid: false,
          error: 'GeometryJSON must include viewport and elements.',
        );
      }

      final GeometryScene scene = GeometryScene.fromJson(json);
      if (scene.elements.isEmpty) {
        return const GeometryValidationResult(
          isValid: false,
          error: 'GeometryJSON elements can not be empty.',
        );
      }

      return GeometryValidationResult(isValid: true, scene: scene);
    } catch (e) {
      return GeometryValidationResult(
        isValid: false,
        error: 'Invalid GeometryJSON: $e',
      );
    }
  }
}
