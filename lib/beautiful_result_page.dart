import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:mathmate/math_recognizer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

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
  String _statusMessage = 'AI 正在全力解析中...';
  Uint8List? _imageBytes;
  final List<String> _textLines = <String>[];
  final List<String> _formulaLines = <String>[];

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
    _startRecognition();
  }

  Future<void> _loadImageBytes() async {
    _imageBytes = await widget.image.readAsBytes();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _startRecognition() async {
    try {
      final String? result = await _recognizer.recognizeFromImage(widget.image);
      if (!mounted || result == null) {
        return;
      }

      final List<String> lines = result
          .split('\n')
          .map((String line) => line.trim())
          .where((String line) => line.isNotEmpty)
          .toList();

      _textLines.clear();
      _formulaLines.clear();

      for (final String line in lines) {
        if (_looksLikeFormula(line)) {
          _formulaLines.add(line);
        } else {
          _textLines.add(line);
        }
      }

      _latex = _formulaLines.isNotEmpty ? _formulaLines.first : null;

      setState(() {
        _isAnalyzing = false;
        _statusMessage = '解析成功！';
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isAnalyzing = false;
        _statusMessage = '出错了: $e';
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

  Future<Uint8List> _sharpenImage(Uint8List originalBytes) async {
    try {
      final img.Image? imageData = img.decodeImage(originalBytes);
      if (imageData == null) {
        return originalBytes;
      }

      img.adjustColor(imageData, contrast: 1.5, gamma: 1.1);
      return Uint8List.fromList(img.encodeJpg(imageData, quality: 90));
    } catch (e) {
      debugPrint('图片处理失败: $e');
      return originalBytes;
    }
  }

  Future<void> _exportPdf() async {
    if (_imageBytes == null) {
      return;
    }

    try {
      final Uint8List sharpBytes = await _sharpenImage(_imageBytes!);
      final pw.Document pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Image(pw.MemoryImage(sharpBytes)),
        ),
      );

      if (kIsWeb) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Web端暂不支持PDF导出')),
          );
        }
        return;
      }

      final Directory dir = await getApplicationDocumentsDirectory();
      final File file = File('${dir.path}/mathmate_scan.pdf');
      await file.writeAsBytes(await pdf.save());

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('PDF 已保存: ${file.path}')));
      }
      await OpenFile.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('导出失败: $e')));
      }
    }
  }

  void _copyLatex() {
    if (_latex == null) {
      return;
    }

    Clipboard.setData(ClipboardData(text: _latex!));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ LaTeX 已复制')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _imageBytes != null
                ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                : const SizedBox.shrink(),
          ),
          Container(color: Colors.black26),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            builder: (_, ScrollController controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '识别结果',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_statusMessage),
                      const Divider(height: 24),
                      if (_isAnalyzing)
                        const Center(child: CircularProgressIndicator())
                      else ...[
                        const Text(
                          '题目内容',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _textLines
                                .map(
                                  (String line) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: SelectableText(
                                      line,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_latex != null) ...[
                          const Text(
                            '公式预览（点击复制 LaTeX）',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _copyLatex,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Math.tex(
                                  _latex!,
                                  textStyle: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _exportPdf,
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text('导出扫描锐化 PDF'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 28,
                                vertical: 14,
                              ),
                              backgroundColor: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
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
}
