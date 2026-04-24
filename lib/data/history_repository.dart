import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mathmate/data/history_models.dart';
import 'package:mathmate/visualization/safe_json_parser.dart';

const String _kIsFirstLaunch = 'is_first_launch';
const String _kGradeLevel = 'grade_level';

class HistoryRepository {
  HistoryRepository._();

  static final HistoryRepository instance = HistoryRepository._();

  Isar? _isar;

  bool get isReady => _isar != null;

  Future<void> init() async {
    if (_isar != null) {
      return;
    }

    final Directory dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      <CollectionSchema>[MathHistorySchema],
      directory: dir.path,
      name: 'mathmate_history',
    );
  }

  Future<void> saveHistory({
    required File sourceImage,
    required String ocrContent,
    required String solutionMarkdown,
    required String latexResult,
    Map<String, dynamic>? sceneMap,
  }) async {
    await init();
    final Isar isar = _isar!;

    final File persistedImage = await _persistImage(sourceImage);
    final SafeJsonParser parser = const SafeJsonParser();

    final MathHistory entity = MathHistory()
      ..timestamp = DateTime.now()
      ..originalImagePath = persistedImage.path
      ..ocrContent = ocrContent
      ..solutionMarkdown = solutionMarkdown
      ..latexResult = latexResult;

    if (sceneMap != null) {
      entity.geometryScene = GeometrySceneEmbedded.fromMap(sceneMap, parser);
    }

    await isar.writeTxn(() async {
      await isar.mathHistorys.put(entity);
    });
  }

  Stream<List<MathHistory>> watchHistories() async* {
    await init();
    final Isar isar = _isar!;

    yield* isar.mathHistorys.where().sortByTimestampDesc().watch(
      fireImmediately: true,
    );
  }

  Future<void> deleteHistory(Id id) async {
    await init();
    final Isar isar = _isar!;

    final MathHistory? history = await isar.mathHistorys.get(id);
    if (history != null) {
      final File image = File(history.originalImagePath);
      if (await image.exists()) {
        try {
          await image.delete();
        } catch (e) {
          debugPrint('delete image failed: $e');
        }
      }
    }

    await isar.writeTxn(() async {
      await isar.mathHistorys.delete(id);
    });
  }

  Future<File> _persistImage(File sourceImage) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final Directory imageDir = Directory(path.join(dir.path, 'history_images'));
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    final String ext = path.extension(sourceImage.path).isEmpty
        ? '.jpg'
        : path.extension(sourceImage.path);
    final String filename =
        'history_${DateTime.now().millisecondsSinceEpoch}$ext';
    final String targetPath = path.join(imageDir.path, filename);

    final File copied = await sourceImage.copy(targetPath);

    try {
      if (await sourceImage.exists()) {
        await sourceImage.delete();
      }
    } catch (e) {
      debugPrint('cleanup temp image failed: $e');
    }

    return copied;
  }

  Future<bool> isFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kIsFirstLaunch) ?? true;
  }

  Future<void> setFirstLaunchComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kIsFirstLaunch, false);
  }

  Future<int?> getGradeLevel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kGradeLevel);
  }

  Future<void> setGradeLevel(int grade) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kGradeLevel, grade);
  }
}
