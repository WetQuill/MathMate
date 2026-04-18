import 'package:image_picker/image_picker.dart';
import 'package:mathmate/models/pipeline_models.dart';
import 'package:mathmate/models/pipeline_stage.dart';
import 'package:mathmate/services/ocr_service.dart';
import 'package:mathmate/services/solver_service.dart';
import 'package:mathmate/services/visualization_service.dart';

class MathPipelineService {
  final OcrService _ocrService;
  final SolverService _solverService;
  final VisualizationService _visualizationService;

  MathPipelineService({
    OcrService? ocrService,
    SolverService? solverService,
    VisualizationService? visualizationService,
  }) : _ocrService = ocrService ?? OcrService(),
       _solverService = solverService ?? SolverService(),
       _visualizationService = visualizationService ?? VisualizationService();

  Future<PipelineResult> runFromImage(
    XFile image, {
    void Function(PipelineStage stage)? onStageChanged,
  }) async {
    final List<String> stageErrors = <String>[];
    RecognizeResult? recognize;
    SolveResult? solve;
    VisualizeResult? visualize;

    try {
      onStageChanged?.call(PipelineStage.recognizing);
      recognize = await _ocrService.recognizeQuestionFromImage(image);
    } catch (e) {
      stageErrors.add('识别阶段失败: $e');
      onStageChanged?.call(PipelineStage.failed);
      return PipelineResult(
        recognize: null,
        solve: null,
        visualize: null,
        stageErrors: stageErrors,
      );
    }

    try {
      onStageChanged?.call(PipelineStage.solving);
      solve = await _solverService.solveQuestionMarkdown(
        recognize.questionMarkdown,
      );
    } catch (e) {
      stageErrors.add('解题阶段失败: $e');
      onStageChanged?.call(PipelineStage.failed);
      return PipelineResult(
        recognize: recognize,
        solve: null,
        visualize: null,
        stageErrors: stageErrors,
      );
    }

    try {
      onStageChanged?.call(PipelineStage.visualizing);
      visualize = await _visualizationService.buildGeometryScene(
        questionMarkdown: recognize.questionMarkdown,
        solutionMarkdown: solve.solutionMarkdown,
      );
      if (visualize.error != null) {
        stageErrors.add('可视化阶段提示: ${visualize.error}');
      }
    } catch (e) {
      stageErrors.add('可视化阶段失败: $e');
    }

    onStageChanged?.call(PipelineStage.completed);
    return PipelineResult(
      recognize: recognize,
      solve: solve,
      visualize: visualize,
      stageErrors: stageErrors,
    );
  }
}
