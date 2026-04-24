import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ScannerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> startScanning(BuildContext context) async {
    try {
      if (kIsWeb) {
        debugPrint('ScannerService: image cropping is not supported on web.');
        return null;
      }
      if (!context.mounted) {
        return null;
      }

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (photo == null) {
        debugPrint('ScannerService: user cancelled taking photo.');
        return null;
      }

      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: photo.path,
        uiSettings: <PlatformUiSettings>[
          AndroidUiSettings(
            toolbarTitle: '裁剪',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: const Color(0xFF4C6FFF),
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: '裁剪',
            cancelButtonTitle: '取消',
            doneButtonTitle: '完成',
          ),
        ],
      );

      if (croppedFile == null) {
        debugPrint('ScannerService: user cancelled cropping.');
        return null;
      }

      final File scannedFile = File(croppedFile.path);
      if (!await scannedFile.exists()) {
        debugPrint(
          'ScannerService: cropped file not found at ${croppedFile.path}',
        );
        return null;
      }

      return scannedFile;
    } catch (e, stackTrace) {
      debugPrint('ScannerService startScanning error: $e');
      debugPrint('$stackTrace');
      return null;
    }
  }
}
