class RecognizeResult {
  final String questionMarkdown;
  final String rawOutput;

  const RecognizeResult({
    required this.questionMarkdown,
    required this.rawOutput,
  });
}

class SolveResult {
  final String solutionMarkdown;
  final String rawOutput;

  const SolveResult({
    required this.solutionMarkdown,
    required this.rawOutput,
  });
}

class VisualizeResult {
  final Map<String, dynamic>? scene;
  final String rawOutput;
  final String? error;

  const VisualizeResult({
    required this.scene,
    required this.rawOutput,
    this.error,
  });
}

class PipelineResult {
  final RecognizeResult? recognize;
  final SolveResult? solve;
  final VisualizeResult? visualize;
  final List<String> stageErrors;

  const PipelineResult({
    this.recognize,
    this.solve,
    this.visualize,
    this.stageErrors = const <String>[],
  });
}
