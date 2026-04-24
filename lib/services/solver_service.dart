import 'package:mathmate/models/pipeline_models.dart';
import 'package:mathmate/services/prompts/solve_prompt.dart';
import 'package:mathmate/services/volc_ai_client_service.dart';

class SolverService {
  static const String _solverModelEnv = 'VOLC_SOLVER_MODEL_ID';

  final VolcAiClientService _client;

  SolverService({VolcAiClientService? client})
    : _client = client ?? VolcAiClientService();

  Future<SolveResult> solveQuestionMarkdown(String questionMarkdown) async {
    final String raw = await _client.callTextPrompt(
      prompt: solvePrompt,
      userText: questionMarkdown,
      modelEnv: _solverModelEnv,
    );

    return SolveResult(solutionMarkdown: raw.trim(), rawOutput: raw);
  }
}
