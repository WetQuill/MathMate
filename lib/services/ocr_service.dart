import 'package:image_picker/image_picker.dart';
import 'package:mathmate/models/pipeline_models.dart';
import 'package:mathmate/services/prompts/ocr_prompt.dart';
import 'package:mathmate/services/volc_ai_client_service.dart';

class OcrService {
  static const String _ocrModelEnv = 'VOLC_OCR_MODEL_ID';

  final VolcAiClientService _client;

  OcrService({VolcAiClientService? client})
    : _client = client ?? VolcAiClientService();

  Future<RecognizeResult> recognizeQuestionFromImage(XFile image) async {
    final String raw = await _client.callVisionPrompt(
      imageFile: image,
      prompt: ocrPrompt,
      modelEnv: _ocrModelEnv,
    );

    return RecognizeResult(
      questionMarkdown: raw.trim(),
      rawOutput: raw,
    );
  }
}
