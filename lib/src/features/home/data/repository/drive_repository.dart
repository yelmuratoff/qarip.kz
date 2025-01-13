import 'dart:async';

import 'package:base_starter/src/common/services/cache/cache_fonts.dart';
import 'package:base_starter/src/features/home/data/models/pagination_files.dart';
import 'package:base_starter/src/features/home/data/models/storage_folder.dart';
import 'package:base_starter/src/features/home/domain/drive_repository.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

final class DriveRepository implements IDriveRepository {
  const DriveRepository();

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
      for (final file in pagination.items) {
        final bodyBytes = await file.getDownloadURL();

        unawaited(
          DynamicCachedFonts.fromFirebase(
            fontFamily: withoutExtension(file.name),
            bucketUrl: bodyBytes,
          ).load(),
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
