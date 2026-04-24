import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mathmate/data/history_models.dart';
import 'package:mathmate/data/history_repository.dart';
import 'package:mathmate/models/pipeline_models.dart';
import 'package:mathmate/models/pipeline_stage.dart';
import 'package:mathmate/services/math_pipeline_service.dart';
import 'package:mathmate/visualization/geometry_validator.dart';
import 'package:mathmate/visualization_page.dart';
import 'package:mathmate/visualization/safe_json_parser.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class BeautifulResultPage extends StatefulWidget {
  final File image;
  final MathHistory? history;
  final String? heroTag;

  const BeautifulResultPage({
    super.key,
    required this.image,
    this.history,
    this.heroTag,
  });

  @override
  State<BeautifulResultPage> createState() => _BeautifulResultPageState();
}

class _BeautifulResultPageState extends State<BeautifulResultPage> {
  final MathPipelineService _pipelineService = MathPipelineService();

  bool _isAnalyzing = true;
  String _statusMessage = '准备开始处理...';

  Uint8List? _imageBytes;
  String _questionMarkdown = '';
  String _solutionMarkdown = '';
  String? _formulaPreview;
  Map<String, dynamic>? _geometryScene;
  String? _geometryMessage;
  List<String> _stageErrors = <String>[];

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
    _bootstrapPage();
  }

  Future<void> _bootstrapPage() async {
    if (widget.history != null) {
      _restoreFromHistory(widget.history!);
      return;
    }
    await _runPipeline();
  }

  Future<void> _loadImageBytes() async {
    _imageBytes = await widget.image.readAsBytes();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _runPipeline() async {
    setState(() {
      _isAnalyzing = true;
      _statusMessage = 'AI 正在解析题目...';
      _stageErrors = <String>[];
    });

    final PipelineResult result = await _pipelineService.runFromImage(
      XFile(widget.image.path),
      onStageChanged: (PipelineStage stage) {
        if (!mounted) {
          return;
        }
        setState(() {
          _statusMessage = _messageForStage(stage);
        });
      },
    );

    if (!mounted) {
      return;
    }

    final String questionMarkdown =
        result.recognize?.questionMarkdown.trim() ?? '';
    final String solutionMarkdown = result.solve?.solutionMarkdown.trim() ?? '';
    final String formulaPreview = _extractFormulaPreview(
      '$questionMarkdown\n$solutionMarkdown',
    );
    final String cleanedLatex = _cleanLatex(formulaPreview);

    final VisualizeResult? visualize = result.visualize;
    final String? geometryMessage = visualize?.scene != null
        ? null
        : visualize?.error ?? '当前未生成可视化数据。';

    setState(() {
      _isAnalyzing = false;
      _questionMarkdown = questionMarkdown;
      _solutionMarkdown = solutionMarkdown;
      _formulaPreview = cleanedLatex.isEmpty ? null : cleanedLatex;
      _geometryScene = visualize?.scene;
      _geometryMessage = geometryMessage;
      _stageErrors = List<String>.from(result.stageErrors);
      _statusMessage = _stageErrors.isEmpty ? '处理完成' : '部分阶段失败，请检查下方提示';
    });

    if (result.recognize != null) {
      _persistHistoryAsync();
    }
  }

  void _restoreFromHistory(MathHistory history) {
    final SafeJsonParser parser = const SafeJsonParser();

    final GeometrySceneEmbedded? scene = history.geometryScene;
    final Map<String, dynamic>? sceneMap = scene?.toMap();

    final String formulaPreview = _extractFormulaPreview(history.latexResult);
    final String cleanedLatex = _cleanLatex(formulaPreview);

    final Map<String, dynamic>? normalizedScene = sceneMap == null
        ? null
        : _normalizeSceneMap(sceneMap, parser);

    Map<String, dynamic>? validatedScene;
    String? geometryMessage;
    if (normalizedScene != null) {
      final GeometryValidationResult validation = const GeometryValidator()
          .validate(normalizedScene);
      if (validation.isValid && validation.scene != null) {
        validatedScene = validation.scene!.toJson();
      } else {
        geometryMessage = validation.error ?? '历史几何数据校验失败。';
      }
    }

    setState(() {
      _isAnalyzing = false;
      _statusMessage = '已加载历史记录';
      _questionMarkdown = history.ocrContent;
      _solutionMarkdown = history.solutionMarkdown;
      _formulaPreview = cleanedLatex.isEmpty ? null : cleanedLatex;
      _geometryScene = validatedScene;
      _geometryMessage =
          geometryMessage ?? (_geometryScene == null ? '历史记录中无可视化数据。' : null);
      _stageErrors = <String>[];
    });
  }

  Map<String, dynamic> _normalizeSceneMap(
    Map<String, dynamic> scene,
    SafeJsonParser parser,
  ) {
    final Map<String, dynamic> viewportRaw = parser.safeMap(
      parser.readValueCaseInsensitive(scene, <String>['viewport']) ??
          <String, dynamic>{},
    );
    final List<dynamic> elementsRaw = parser.safeList(
      parser.readValueCaseInsensitive(scene, <String>['elements']) ??
          <dynamic>[],
    );

    final Map<String, dynamic> normalizedViewport = <String, dynamic>{
      'xMin': parser.safeToDouble(
        parser.readValueCaseInsensitive(viewportRaw, <String>['xMin', 'xmin']),
        -5.0,
      ),
      'xMax': parser.safeToDouble(
        parser.readValueCaseInsensitive(viewportRaw, <String>['xMax', 'xmax']),
        5.0,
      ),
      'yMin': parser.safeToDouble(
        parser.readValueCaseInsensitive(viewportRaw, <String>['yMin', 'ymin']),
        -5.0,
      ),
      'yMax': parser.safeToDouble(
        parser.readValueCaseInsensitive(viewportRaw, <String>['yMax', 'ymax']),
        5.0,
      ),
    };

    final List<Map<String, dynamic>> normalizedElements = elementsRaw
        .map((dynamic e) => parser.safeMap(e))
        .toList();

    return <String, dynamic>{
      'viewport': normalizedViewport,
      'elements': normalizedElements,
    };
  }

  Future<void> _persistHistoryAsync() async {
    try {
      await HistoryRepository.instance.saveHistory(
        sourceImage: widget.image,
        ocrContent: _questionMarkdown,
        solutionMarkdown: _solutionMarkdown,
        latexResult: _cleanLatex(_formulaPreview ?? _solutionMarkdown),
        sceneMap: _geometryScene,
      );
    } catch (e) {
      debugPrint('save history failed: $e');
    }
  }

  String _cleanLatex(String input) {
    String text = input.trim();
    if (text.isEmpty) {
      return text;
    }

    text = text.replaceAllMapped(
      RegExp(r'\\\\(begin|end)\{'),
      (Match match) => '\\${match.group(1)}{',
    );

    text = text
        .replaceAll(r'\begin{cases}', r'\begin{aligned}')
        .replaceAll(r'\end{cases}', r'\end{aligned}');

    final List<String> rows = text.split(r'\\');
    if (rows.length > 1) {
      final List<String> normalizedRows = rows.map((String row) {
        final String cleaned = row.trim();
        if (cleaned.isEmpty || cleaned.contains('&')) {
          return cleaned;
        }
        return '& $cleaned';
      }).toList();
      text = normalizedRows.join(r'\\');
    }

    text = text.replaceFirst(RegExp(r'[，。；：、,.!?！？]+$'), '');
    return text;
  }

  String _messageForStage(PipelineStage stage) {
    switch (stage) {
      case PipelineStage.idle:
        return '等待开始';
      case PipelineStage.recognizing:
        return '正在识别题目文本...';
      case PipelineStage.solving:
        return '正在生成解答过程...';
      case PipelineStage.visualizing:
        return '正在生成可视化 JSON...';
      case PipelineStage.completed:
        return '处理完成';
      case PipelineStage.failed:
        return '流程失败';
    }
  }

  String _extractFormulaPreview(String input) {
    final RegExp displayMath = RegExp(r'\$\$([\s\S]*?)\$\$');
    final RegExp inlineMath = RegExp(r'\$([^\$\n]+)\$');

    final RegExpMatch? displayMatch = displayMath.firstMatch(input);
    if (displayMatch != null) {
      return (displayMatch.group(1) ?? '').trim();
    }

    final RegExpMatch? inlineMatch = inlineMath.firstMatch(input);
    if (inlineMatch != null) {
      return (inlineMatch.group(1) ?? '').trim();
    }

    final List<String> lines = input
        .split('\n')
        .map((String line) => line.trim())
        .where((String line) => line.isNotEmpty)
        .toList();

    for (final String line in lines) {
      if (_looksLikeFormula(line)) {
        return line;
      }
    }

    return '';
  }

  bool _looksLikeFormula(String text) {
    return text.contains(r'\') ||
        text.contains('_') ||
        text.contains('^') ||
        text.contains('{') ||
        text.contains('}') ||
        text.contains('=');
  }

  Future<void> _exportPdf() async {
    try {
      final pw.Document pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return <pw.Widget>[
              pw.Header(
                level: 0,
                child: pw.Text(
                  'MathMate 识别结果',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text(
                  '题目内容（OCR）',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                _questionMarkdown.isNotEmpty
                    ? _stripMarkdown(_questionMarkdown)
                    : '（题目识别为空）',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text(
                  '解答过程',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                _solutionMarkdown.isNotEmpty
                    ? _stripMarkdown(_solutionMarkdown)
                    : '（解题阶段未返回内容）',
                style: const pw.TextStyle(fontSize: 12),
              ),
              if (_formulaPreview != null &&
                  _formulaPreview!.isNotEmpty) ...<pw.Widget>[
                pw.SizedBox(height: 20),
                pw.Header(
                  level: 1,
                  child: pw.Text(
                    '公式预览',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  child: pw.Text(
                    _cleanLatexForPdf(_formulaPreview!),
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ];
          },
        ),
      );

      if (kIsWeb) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Web端暂不支持PDF导出')));
        }
        return;
      }

      final Directory dir = await getApplicationDocumentsDirectory();
      final File file = File('${dir.path}/mathmate_result.pdf');
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

  String _stripMarkdown(String text) {
    return text
        .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1')
        .replaceAll(RegExp(r'\*([^*]+)\*'), r'$1')
        .replaceAll(RegExp(r'#{1,6}\s*'), '')
        .replaceAll(RegExp(r'\$+\$?([\s\S]*?)\$+\$?'), r'$1')
        .replaceAll(RegExp(r'`([^`]+)`'), r'$1')
        .replaceAll(RegExp(r'```[\s\S]*?```'), '')
        .replaceAll(RegExp(r'!\[([^\]]*)\]\([^)]+\)'), '')
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1')
        .replaceAll(RegExp(r'^\s*[-*+]\s+', multiLine: true), '')
        .replaceAll(RegExp(r'^\s*\d+\.\s+', multiLine: true), '')
        .trim();
  }

  String _cleanLatexForPdf(String latex) {
    return latex
        .replaceAll(RegExp(r'\\frac\{([^}]+)\}\{([^}]+)\}'), r'($1)/($2)')
        .replaceAll(RegExp(r'\\sqrt\{([^}]+)\}'), r'√($1)')
        .replaceAllMapped(RegExp(r'\\sqrt(\d)'), (Match m) => '√${m[1]}')
        .replaceAll(r'\\times', '×')
        .replaceAll(r'\\div', '÷')
        .replaceAll(r'\\pm', '±')
        .replaceAll(r'\\mp', '∓')
        .replaceAll(r'\\leq', '≤')
        .replaceAll(r'\\geq', '≥')
        .replaceAll(r'\\neq', '≠')
        .replaceAll(r'\\approx', '≈')
        .replaceAll(r'\\equiv', '≡')
        .replaceAll(r'\\infty', '∞')
        .replaceAll(r'\\alpha', 'α')
        .replaceAll(r'\\beta', 'β')
        .replaceAll(r'\\gamma', 'γ')
        .replaceAll(r'\\delta', 'δ')
        .replaceAll(r'\\pi', 'π')
        .replaceAll(r'\\theta', 'θ')
        .replaceAll(r'\\lambda', 'λ')
        .replaceAll(r'\\mu', 'μ')
        .replaceAll(r'\\sigma', 'σ')
        .replaceAll(r'\\phi', 'φ')
        .replaceAll(r'\\psi', 'ψ')
        .replaceAll(r'\\omega', 'ω')
        .replaceAll(r'\\Delta', 'Δ')
        .replaceAll(r'\\Sigma', 'Σ')
        .replaceAll(r'\\Omega', 'Ω')
        .replaceAll(r'\\cdot', '·')
        .replaceAll(r'\\ldots', '...')
        .replaceAll(r'\\rightarrow', '→')
        .replaceAll(r'\\leftarrow', '←')
        .replaceAll(r'\\Rightarrow', '⇒')
        .replaceAll(r'\\Leftarrow', '⇐')
        .replaceAll(r'\\leftrightarrow', '↔')
        .replaceAll(r'\\Leftrightarrow', '⇔')
        .replaceAll(r'\\in', '∈')
        .replaceAll(r'\\notin', '∉')
        .replaceAll(r'\\subset', '⊂')
        .replaceAll(r'\\subseteq', '⊆')
        .replaceAll(r'\\cup', '∪')
        .replaceAll(r'\\cap', '∩')
        .replaceAll(r'\\forall', '∀')
        .replaceAll(r'\\exists', '∃')
        .replaceAll(r'\\partial', '∂')
        .replaceAll(r'\\nabla', '∇')
        .replaceAll(r'\\begin\{cases\}', '')
        .replaceAll(r'\\end\{cases\}', '')
        .replaceAll(r'\\begin\{aligned\}', '')
        .replaceAll(r'\\end\{aligned\}', '')
        .replaceAll(r'\\begin\{matrix\}', '')
        .replaceAll(r'\\end\{matrix\}', '')
        .replaceAll(r'\\begin\{bmatrix\}', '[')
        .replaceAll(r'\\end\{bmatrix\}', ']')
        .replaceAll(r'\\begin\{pmatrix\}', '(')
        .replaceAll(r'\\end\{pmatrix\}', ')')
        .replaceAll(r'\\begin\{vmatrix\}', '|')
        .replaceAll(r'\\end\{vmatrix\}', '|')
        .replaceAll(r'\\begin\{smallmatrix\}', '')
        .replaceAll(r'\\end\{smallmatrix\}', '')
        .replaceAll(r'\\left', '')
        .replaceAll(r'\\right', '')
        .replaceAll(r'\\ ', ' ')
        .replaceAll(r'\\quad', '  ')
        .replaceAll(r'\\qquad', '    ')
        .replaceAll(r'\\\\', '\n')
        .replaceAll(r'\\\{', '{')
        .replaceAll(r'\\\}', '}')
        .replaceAll(r'\{', '')
        .replaceAll(r'\}', '')
        .replaceAll(r'\_', '_')
        .replaceAll(r'\^', '^')
        .replaceAll(RegExp(r'\\text\{([^}]+)\}'), r'$1')
        .replaceAll(RegExp(r'\\textbf\{([^}]+)\}'), r'$1')
        .replaceAll(RegExp(r'\\textit\{([^}]+)\}'), r'$1')
        .replaceAll(RegExp(r'\\mathsf\{([^}]+)\}'), r'$1')
        .replaceAll(RegExp(r'\\mathrm\{([^}]+)\}'), r'$1')
        .replaceAll(RegExp(r'\\mathbf\{([^}]+)\}'), r'$1')
        .replaceAll(RegExp(r'\\mathit\{([^}]+)\}'), r'$1')
        .replaceAll(r'\\_', '_')
        .replaceAll(r'\\%', '%')
        .trim();
  }

  void _copyFormula() {
    final String? formula = _formulaPreview;
    if (formula == null || formula.isEmpty) {
      return;
    }

    Clipboard.setData(ClipboardData(text: formula));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ 公式已复制')));
    }
  }

  Widget _buildMarkdownBlock({
    required String title,
    required String content,
    String emptyText = '暂无内容',
  }) {
    if (content.trim().isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(emptyText, style: const TextStyle(fontSize: 14)),
          ),
        ],
      );
    }

    final List<Widget> blocks = _buildContentBlocks(content);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: blocks.length == 1 && blocks.first is Math
              ? blocks.first
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: blocks
                      .map(
                        (Widget w) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: w,
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  List<Widget> _buildContentBlocks(String content) {
    final List<Widget> widgets = <Widget>[];
    final RegExp displayMathRegex = RegExp(r'\$\$(.*?)\$\$', dotAll: true);

    int lastEnd = 0;
    for (final RegExpMatch match in displayMathRegex.allMatches(content)) {
      if (match.start > lastEnd) {
        final String textBefore = content
            .substring(lastEnd, match.start)
            .trim();
        if (textBefore.isNotEmpty) {
          widgets.add(_buildMarkdownText(textBefore));
        }
      }

      final String latex = match.group(1)?.trim() ?? '';
      if (latex.isNotEmpty) {
        try {
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Math.tex(
                  latex,
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        } catch (e) {
          widgets.add(
            Text(latex, style: const TextStyle(fontFamily: 'monospace')),
          );
        }
      }

      lastEnd = match.end;
    }

    if (lastEnd < content.length) {
      final String textAfter = content.substring(lastEnd).trim();
      if (textAfter.isNotEmpty) {
        widgets.add(_buildMarkdownText(textAfter));
      }
    }

    if (widgets.isEmpty) {
      widgets.add(_buildMarkdownText(content));
    }

    return widgets;
  }

  Widget _buildMarkdownText(String text) {
    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: const TextStyle(fontSize: 14, height: 1.45),
        h1: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        h2: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        h3: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        code: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
        blockquote: const TextStyle(color: Colors.blueGrey),
      ),
    );
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
        children: <Widget>[
          Positioned.fill(
            child: _imageBytes == null
                ? const SizedBox.shrink()
                : (widget.heroTag == null
                      ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                      : Hero(
                          tag: widget.heroTag!,
                          child: Image.memory(_imageBytes!, fit: BoxFit.cover),
                        )),
          ),
          Container(color: Colors.black26),
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.2,
            maxChildSize: 0.92,
            builder: (BuildContext context, ScrollController controller) {
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
                    children: <Widget>[
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
                      if (_stageErrors.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 8),
                        ..._stageErrors.map(
                          (String error) => Text(
                            '• $error',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                      const Divider(height: 24),
                      if (_isAnalyzing)
                        const Center(child: CircularProgressIndicator())
                      else ...<Widget>[
                        _buildMarkdownBlock(
                          title: '题目内容（OCR）',
                          content: _questionMarkdown,
                          emptyText: '题目识别为空',
                        ),
                        const SizedBox(height: 16),
                        _buildMarkdownBlock(
                          title: '解答过程（Markdown）',
                          content: _solutionMarkdown,
                          emptyText: '解题阶段未返回内容',
                        ),
                        const SizedBox(height: 20),
                        if (_formulaPreview != null) ...<Widget>[
                          const Text(
                            '公式预览（点击复制）',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _copyFormula,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Math.tex(
                                  _formulaPreview!,
                                  textStyle: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        if (_geometryScene != null)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => VisualizationPage(
                                      scene: _geometryScene!,
                                      title: '几何可视化',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.visibility_outlined,
                                color: Colors.black87,
                              ),
                              label: const Text(
                                '查看几何可视化',
                                style: TextStyle(color: Colors.black87),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF90CAF9),
                              ),
                            ),
                          )
                        else
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _geometryMessage ?? '暂未生成可视化数据。',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.blueGrey),
                            ),
                          ),
                        const SizedBox(height: 20),
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
