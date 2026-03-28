import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:mathmate/math_recognizer.dart'; // 假设你的项目名叫 mathmate

class BeautifulResultPage extends StatefulWidget {
  final XFile image;
  const BeautifulResultPage({super.key, required this.image});

  @override
  State<BeautifulResultPage> createState() => _BeautifulResultPageState();
}

class _BeautifulResultPageState extends State<BeautifulResultPage> {
  final MathRecognizer _recognizer = MathRecognizer();
  String? _latex;
  bool _isAnalyzing = true;
  String _statusMessage = "AI 正在全力解析中...";

  @override
  void initState() {
    super.initState();
    _startRecognition();
  }

  Future<void> _startRecognition() async {
    try {
      final result = await _recognizer.recognizeFromImage(widget.image);
      if (mounted) {
        setState(() {
          _latex = result;
          _isAnalyzing = false;
          _statusMessage = (result == null || result.isEmpty)
              ? "解析失败，请确保公式清晰"
              : "解析成功！";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _statusMessage = "出错了: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 允许背景图延伸到状态栏下方
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // --- 第一层：全屏背景图片 (带 Hero) ---
          Positioned.fill(
            child: Hero(
              tag: 'math_pic', // 必须和上一页匹配
              child: Image.file(
                File(widget.image.path),
                fit: BoxFit.cover, // 填充模式
              ),
            ),
          ),
          // 为了让顶部的按钮更清晰，加一个淡淡的半透明遮罩
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),

          // --- 第二层：可拖拽滑动面板 (的核心) ---
          DraggableScrollableSheet(
            initialChildSize: 0.4, // 初始高度：屏幕的 40%
            minChildSize: 0.15, // 最小高度：屏幕的 15%
            maxChildSize: 0.9, // 最大高度：屏幕的 90%
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController, // 必须将此 controller 绑定
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- 面板顶部的“小抓手”指示器 ---
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // --- 标题和状态 ---
                      Text(
                        "解析结果",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _statusMessage,
                        style: TextStyle(
                          color: _isAnalyzing ? Colors.blue : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const Divider(height: 30),

                      // --- 动态内容区域 ---
                      if (_isAnalyzing)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_latex != null && _latex!.isNotEmpty)
                        _buildResultArea()
                      else
                        const Center(
                          child: Icon(
                            Icons.error_outline,
                            size: 50,
                            color: Colors.amber,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 构建结果展示区（LaTex 和 渲染公式）
  Widget _buildResultArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "LaTeX 代码:",
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8, bottom: 20),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            _latex!,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
              color: Colors.blueGrey,
            ),
          ),
        ),
        Text(
          "标准公式预览:",
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        // 这里使用了之前修复的 textStyle 语法
        Center(
          child: Math.tex(
            _latex!,
            mathStyle: MathStyle.display,
            textStyle: TextStyle(fontSize: 28, color: Colors.grey[900]),
          ),
        ),
      ],
    );
  }
}
