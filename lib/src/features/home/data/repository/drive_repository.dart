import 'dart:async';

import 'package:base_starter/src/common/services/cache/cache_service.dart';
import 'package:base_starter/src/features/home/data/models/pagination_files.dart';
import 'package:base_starter/src/features/home/data/models/storage_folder.dart';
import 'package:base_starter/src/features/home/domain/drive_repository.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

final class DriveRepository implements IDriveRepository {
  const DriveRepository({
    required this.prefs,
  });

  final SharedPreferences prefs;

  @override
  Future<PaginationFiles> getFiles({
    required String? path,
    required String? pageToken,
  }) async {
    try {
      final pagination = await FirebaseStorage.instance.ref(path).list(
            ListOptions(
              pageToken: pageToken,
              maxResults: 10,
            ),
          );

      //
      // <--- Cache --->
      //
      // for (final file in pagination.items) {
      //   final uint8List = await file.getData();

      //   final byteData = ByteData.sublistView(uint8List!);

      //   final fontLoader = FontLoader(withoutExtension(file.name))
      //     ..addFont(Future.value(byteData));
      //   await fontLoader.load();
      // }

      //     final byteData = ByteData.sublistView(fontBytes);
      // final fontLoader = FontLoader(fontName)
      // ..addFont(Future.value(byteData));
      // await fontLoader.load();

      final fontCacheManager = FontCacheManager();

      for (final file in pagination.items) {
        // fontCacheService.loadFontSync(withoutExtension(file.name), () async {
        //   final uint8List = await file.getData();
        //   if (uint8List == null) {
        //     throw Exception("Unable to load data for file: ${file.name}");
        //   }
        //   return uint8List;
        // });
        final url = await file.getDownloadURL();
        unawaited(
          fontCacheManager.loadFont(
            url,
            withoutExtension(file.name),
          ),
        );
      }

      //
      // <--- Parse --->
      //
      final files = await compute(
        _parseFiles,
        pagination,
      );

      return PaginationFiles(
        files: files,
        nextPageToken: pagination.nextPageToken,
        hasMore: pagination.nextPageToken != null,
      );
    } catch (e) {
      rethrow;
    }
  }

  static List<StorageFile> _parseFiles(ListResult files) => [
        ...files.items.map(StorageFile.fromReference),
        ...files.prefixes.map(StorageFile.fromReference),
      ];

  @override
  Future<void> downloadFont(
    String path,
  ) async {
    try {
      final storageRef = FirebaseStorage.instance.ref(path);
      final url = await storageRef.getDownloadURL();

      await launchUrl(Uri.parse(url));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<StorageFile>> getCategories() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final listResult = await storageRef.list();

      return compute(
        _parseCategories,
        listResult,
      );
    } catch (e) {
      rethrow;
    }
  }

  static List<StorageFile> _parseCategories(ListResult listResult) =>
      listResult.prefixes.map(StorageFile.fromReference).toList();
}
