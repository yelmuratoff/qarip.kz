import 'package:base_starter/src/features/home/data/models/storage_folder.dart';
import 'package:equatable/equatable.dart';

final class PaginationFiles extends Equatable {
  const PaginationFiles({
    required this.files,
    required this.nextPageToken,
    required this.hasMore,
  });

  final List<StorageFile> files;
  final String? nextPageToken;
  final bool hasMore;

  @override
  List<Object?> get props => [
        files,
        nextPageToken,
        hasMore,
      ];
}
