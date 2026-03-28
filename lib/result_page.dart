import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:mathmate/math_recognizer.dart';

class ResultPage extends StatefulWidget {
  final XFile image; // 接收传递过来的图片

  const ResultPage({super.key, required this.image});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final MathRecognizer _recognizer = MathRecognizer();
  String? _latex;
  bool _isAnalyzing = true;

  @override
  void initState() {
    super.initState();
    _startRecognition();
  }

  // 页面初始化后立即开始识别
  Future<void> _startRecognition() async {
    final result = await _recognizer.recognizeFromImage(widget.image);
    if (mounted) {
      setState(() {
        _latex = result;
        _isAnalyzing = false;
      });
    }
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
                      SelectableText(_latex ?? "识别失败"),
                      const Divider(),
                      if (_latex != null)
                        Math.tex(
                          _latex!,
                          mathStyle: MathStyle.display, // 推荐加上，公式更美观
                          textStyle: const TextStyle(fontSize: 24), // 在这里设置字号
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
