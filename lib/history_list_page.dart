import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mathmate/beautiful_result_page.dart';
import 'package:mathmate/data/history_models.dart';
import 'package:mathmate/data/history_repository.dart';

class HistoryListPage extends StatelessWidget {
  const HistoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('历史记录')),
      backgroundColor: const Color(0xFFF7FAFF),
      body: StreamBuilder<List<MathHistory>>(
        stream: HistoryRepository.instance.watchHistories(),
        builder: (BuildContext context, AsyncSnapshot<List<MathHistory>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<MathHistory> histories = snapshot.data ?? <MathHistory>[];
          if (histories.isEmpty) {
            return const Center(
              child: Text(
                '还没有历史记录',
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: histories.length,
            itemBuilder: (BuildContext context, int index) {
              final MathHistory item = histories[index];
              final String heroTag = 'history-image-${item.id}';
              return _HistoryCard(
                item: item,
                heroTag: heroTag,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BeautifulResultPage(
                        image: File(item.originalImagePath),
                        history: item,
                        heroTag: heroTag,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final MathHistory item;
  final String heroTag;
  final VoidCallback onTap;

  const _HistoryCard({
    required this.item,
    required this.heroTag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime t = item.timestamp;
    final String dateText =
        '${t.year.toString().padLeft(4, '0')}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')} '
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    final String preview = item.latexResult.trim().isEmpty
        ? '无公式预览'
        : item.latexResult.trim().replaceAll('\n', ' ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(item.originalImagePath),
                      width: 86,
                      height: 86,
                      fit: BoxFit.cover,
                      cacheWidth: 260,
                      cacheHeight: 260,
                      errorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return Container(
                          width: 86,
                          height: 86,
                          color: const Color(0xFFEAEFFB),
                          child: const Icon(Icons.broken_image_outlined),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        dateText,
                        style: TextStyle(
                          color: Colors.blueGrey.shade700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        preview,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
