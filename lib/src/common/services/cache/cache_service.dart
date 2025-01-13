import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FontCacheManager {
  static final _cacheManager = DefaultCacheManager();

  Future<void> loadFont(String url, String fontName) async {
    try {
      final fileInfo = await _cacheManager.getFileFromCache(url);
      Uint8List fontBytes;

      if (fileInfo != null && fileInfo.file.existsSync()) {
        fontBytes = await fileInfo.file.readAsBytes();
      } else {
        final file = await _cacheManager.downloadFile(url);
        fontBytes = await file.file.readAsBytes();
      }

      final byteData = ByteData.sublistView(fontBytes);
      final fontLoader = FontLoader(fontName)..addFont(Future.value(byteData));
      await fontLoader.load();
    } catch (e) {
      debugPrint('Ошибка загрузки шрифта: $e');
    }
  }

  /// Очищает кэш шрифтов
  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}
