import 'package:flutter/material.dart';

class AboutMathMatePage extends StatelessWidget {
  const AboutMathMatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于 MathMate')),
      backgroundColor: const Color(0xFFF7FAFF),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
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
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.calculate_rounded, size: 52, color: Color(0xFF3F51B5)),
              SizedBox(height: 12),
              Text(
                'MathMate',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 6),
              Text('Version 1.0.0', style: TextStyle(color: Color(0xFF8E98A8))),
              SizedBox(height: 12),
              Text(
                '拍照识别 + AI 解题 + 几何可视化\n让数学学习更直观。',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
