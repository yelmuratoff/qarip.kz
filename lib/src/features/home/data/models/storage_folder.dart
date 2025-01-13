import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

final class StorageFile extends Equatable {
  const StorageFile({
    required this.id,
    this.name,
    this.bucket,
    this.fullPath,
    this.parent,
    this.mimeType,
    this.withoutExtension,
  });

  factory StorageFile.fromReference(Reference reference) => StorageFile(
        id: reference.hashCode,
        name: reference.name,
        withoutExtension: path.withoutExtension(reference.name),
        bucket: reference.bucket,
        fullPath: reference.fullPath,
        parent: reference.parent != null
            ? StorageFile.fromReference(
                reference.parent!,
              )
            : null,
        mimeType: extensionFromMime(
          lookupMimeType(reference.name) ?? '',
        ),
      );

  final int id;
  final String? name;
  final String? bucket;
  final String? fullPath;
  final StorageFile? parent;
  final String? mimeType;
  final String? withoutExtension;

  bool get isFolder => mimeType == null;

  @override
  List<Object?> get props => [
        id,
        name,
        bucket,
        fullPath,
        parent,
        mimeType,
        withoutExtension,
      ];
}
