import 'dart:io';

import 'package:base_starter/src/common/services/file/src/base_service.dart';
import 'package:path_provider/path_provider.dart';

class FileService implements BaseFileService {
  const FileService._();

  static const BaseFileService _service = FileService._();
  static BaseFileService get instance => _service;

  @override
  Future<void> deleteAppDir() => _deleteAppDir();

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  @override
  Future<void> deleteCacheDir() => _deleteCacheDir();

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  @override
  Future<List<File>> getFiles() => _getFilesList();

  Future<List<File>> _getFilesList() async {
    final fileModels = <File>[];
    final cacheDir = await getTemporaryDirectory();
    final files = cacheDir.listSync();
    for (final file in files) {
      final fileModel = File(file.path);
      fileModels.add(fileModel);
    }
    return fileModels;
  }
}
