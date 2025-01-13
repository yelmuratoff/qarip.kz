import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';

final class StorageFile extends Equatable {
  const StorageFile({
    required this.id,
    this.name,
    this.bucket,
    this.fullPath,
    this.parent,
  });

  factory StorageFile.fromReference(Reference reference) => StorageFile(
        id: reference.hashCode,
        name: reference.name,
        bucket: reference.bucket,
        fullPath: reference.fullPath,
        parent: reference.parent != null
            ? StorageFile.fromReference(
                reference.parent!,
              )
            : null,
      );

  final int id;
  final String? name;
  final String? bucket;
  final String? fullPath;
  final StorageFile? parent;

  @override
  List<Object?> get props => [
        id,
        name,
        bucket,
        fullPath,
        parent,
      ];
}
