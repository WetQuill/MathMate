import 'package:flutter/material.dart';
import 'package:mathmate/visualization/jxg_webview.dart';

class VisualizationPage extends StatefulWidget {
  final Map<String, dynamic> scene;
  final String title;

  const VisualizationPage({
    super.key,
    required this.scene,
    this.title = '几何可视化',
  });

  @override
  State<VisualizationPage> createState() => _VisualizationPageState();
}

class _VisualizationPageState extends State<VisualizationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: JxgWebView(
            scene: widget.scene,
            onEngineError: (String message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
          ),
        ),
      ),
    );
  }
}
