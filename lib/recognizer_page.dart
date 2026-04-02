import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mathmate/beautiful_result_page.dart';

class RecognizerPage extends StatefulWidget {
  const RecognizerPage({super.key});

  @override
  State<RecognizerPage> createState() => _RecognizerPageState();
}

class _RecognizerPageState extends State<RecognizerPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _processImage(ImageSource source) async {
    final XFile? selected = await _picker.pickImage(source: source);
    if (selected == null || !mounted) return;

    setState(() {
      _image = selected;
    });

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BeautifulResultPage(image: selected)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('公式识别插件'),
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
      ),
      body: Column(
        children: [
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
        ],
      ),
    );
  }
}
