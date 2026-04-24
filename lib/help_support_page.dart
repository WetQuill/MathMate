import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('帮助与支持')),
      backgroundColor: const Color(0xFFF7FAFF),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const <Widget>[
          _FaqCard(
            question: '如何快速拍照识别？',
            answer: '进入“题目”页点击中心蓝色拍照按钮，完成裁切后自动识别。',
          ),
          SizedBox(height: 10),
          _FaqCard(question: '历史记录在哪里查看？', answer: '在“我的”页面点击“历史记录”即可查看全部题目。'),
          SizedBox(height: 10),
          _FaqCard(question: '公式显示异常怎么办？', answer: '可尝试重新拍照，保持画面清晰并完整包含题干。'),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqCard({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            question,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF5D6778),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
