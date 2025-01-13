import 'package:base_starter/src/features/home/data/models/pagination_files.dart';
import 'package:base_starter/src/features/home/data/models/storage_folder.dart';
import 'package:base_starter/src/features/home/domain/drive_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

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

  static List<StorageFile> _parseFiles(ListResult files) =>
      files.items.map(StorageFile.fromReference).toList();

  // Future<void> _loadFonts(List<File> files) async {
  //   for (final file in files) {
  //     if (isFont(file.mimeType)) {
  //       await DynamicCachedFonts(
  //         fontFamily: file.name ?? '',
  //         url:
  //             'https://www.googleapis.com/drive/v3/files/${file.id}?alt=media&source=downloadUrl&key=${Env.apiKey}',
  //       ).load();
  //       // final media = await _authClient.get(
  //       //   Uri.parse(
  //       //     'https://www.googleapis.com/drive/v3/files/${file.id}?alt=media&source=downloadUrl',
  //       //   ),
  //       // );

  //       // final byteData = ByteData.sublistView(media.bodyBytes);

  //       // final fontLoader = FontLoader(file.name ?? '')
  //       //   ..addFont(Future.value(byteData));
  //       // await fontLoader.load();
  //     }
  //   }
  // }

  Future<void> downloadFont(
    String id,
    String mimeType,
  ) async {
    try {
      // await _driveApi.files.export(
      //   id,
      //   mimeType,
      // );
    } catch (e) {
      rethrow;
    }
  }

  static bool isFont(String? mimeType) => switch (mimeType) {
        'font/ttf' || 'font/otf' || 'font/woff' || 'font/woff2' => true,
        _ => false,
      };

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
