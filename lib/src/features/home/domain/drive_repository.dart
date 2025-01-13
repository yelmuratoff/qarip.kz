import 'package:base_starter/src/features/home/data/models/pagination_files.dart';
import 'package:base_starter/src/features/home/data/models/storage_folder.dart';

abstract interface class IDriveRepository {
  Future<PaginationFiles> getFiles({
    required String? path,
    required String? pageToken,
  });

  Future<List<StorageFile>> getCategories();

  Future<void> downloadFont(
    String path,
  );
}
