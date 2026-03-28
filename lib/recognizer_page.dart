import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:mathmate/math_recognizer.dart';
import 'package:flutter/foundation.dart';
import 'result_page.dart';
import 'beautiful_result_page.dart';

class RecognizerPage extends StatefulWidget {
  const RecognizerPage({super.key});

  @override
  State<RecognizerPage> createState() => _RecognizerPageState();
}

class _RecognizerPageState extends State<RecognizerPage> {
  final ImagePicker _picker = ImagePicker();
  final MathRecognizer _recognizer = MathRecognizer();

  XFile? _image;
  String? _latexResult;
  bool _isLoading = false;

  Future<void> _processImage(ImageSource source) async {
    final XFile? selected = await _picker.pickImage(source: source);
    if (selected == null) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeautifulResultPage(image: selected), // 将选中的图片传过去
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('公式识别插件 '),
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
      ),
      body: Column(
        children: [
          // 图片预览区
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: _image == null
                  ? const Center(child: Text('请上传或拍摄手写公式'))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(_image!.path, fit: BoxFit.contain)
                          : Image.file(File(_image!.path), fit: BoxFit.contain),
                    ),
            ),
          ),

          // 按钮区
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _processImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('拍照'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _processImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('相册'),
                ),
              ],
            ),
          ),

          // 结果显示区
          Container(
            padding: const EdgeInsets.all(20),
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _latexResult == null
                ? const Center(child: Text('识别结果将显示在这里'))
                : Column(
                    children: [
                      const Text(
                        '识别到的 LaTeX:',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SelectableText(
                        _latexResult!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Divider(height: 30),
                      const Text('公式预览:', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 10),
                      Math.tex(
                        _latexResult!,
                        mathStyle: MathStyle.display, // 使用“显示模式”，会让分数看起来更舒展、更形象
                        textStyle: const TextStyle(
                          fontSize: 28,
                          color: Colors.blueAccent,
                        ), // 把字号加大到 28
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
