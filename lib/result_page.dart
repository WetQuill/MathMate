import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:mathmate/math_recognizer.dart';
import 'package:mathmate/visualization/geometry_validator.dart';
import 'package:mathmate/visualization/response_extractor.dart';

@Deprecated('Use BeautifulResultPage instead. This page is no longer in use.')
class ResultPage extends StatefulWidget {
  final XFile image; // 接收传递过来的图片

  const ResultPage({super.key, required this.image});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final MathRecognizer _recognizer = MathRecognizer();
  String? _fullResponse;
  String _cleanFormulaText = '';
  String? _geometryMessage;
  bool _isAnalyzing = true;

  @override
  void initState() {
    super.initState();
    _startRecognition();
  }

  // 页面初始化后立即开始识别
  Future<void> _startRecognition() async {
    final String? result = await _recognizer.recognizeFromImage(widget.image);

    String cleanFormulaText = '';
    String? geometryMessage;

    if (result != null && result.trim().isNotEmpty) {
      final ExtractedResponse extracted = ResponseExtractor.split(result);
      cleanFormulaText = extracted.cleanFormulaText;

      if (extracted.geometryJsonText != null) {
        try {
          final dynamic decoded = jsonDecode(extracted.geometryJsonText!);
          if (decoded is Map<String, dynamic>) {
            final GeometryValidationResult validation =
                const GeometryValidator().validate(decoded);
            if (!validation.isValid) {
              geometryMessage = validation.error;
            }
          } else {
            geometryMessage = 'GeometryJSON 格式错误：根节点必须是对象。';
          }
        } catch (e) {
          geometryMessage = 'GeometryJSON 解析失败：$e';
        }
      }
    }

    if (mounted) {
      setState(() {
        _fullResponse = result;
        _cleanFormulaText = cleanFormulaText;
        _geometryMessage = geometryMessage;
        _isAnalyzing = false;
      });
    }
  }

  bool _looksLikeFormula(String text) {
    return text.contains(r'\') ||
        text.contains('_') ||
        text.contains('^') ||
        text.contains('{') ||
        text.contains('}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('识别结果')),
      body: Column(
        children: [
          // 上半部分：显示拍摄的图片
          Expanded(
            child: Image.file(File(widget.image.path), fit: BoxFit.contain),
          ),
          // 下半部分：显示 LaTeX 结果
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: _isAnalyzing
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      const Text("识别结果 (LaTeX):"),
                      SelectableText(_fullResponse ?? "识别失败"),
                      const Divider(),
                      if (_cleanFormulaText.isNotEmpty &&
                          _looksLikeFormula(_cleanFormulaText))
                        Math.tex(
                          _cleanFormulaText,
                          mathStyle: MathStyle.display, // 推荐加上，公式更美观
                          textStyle: const TextStyle(fontSize: 24), // 在这里设置字号
                        ),
                      if (_geometryMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _geometryMessage!,
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
