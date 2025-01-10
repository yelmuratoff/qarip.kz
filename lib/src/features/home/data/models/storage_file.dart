import 'package:supabase_flutter/supabase_flutter.dart';

final class StorageFile {
  const StorageFile({
    required this.name,
    this.bucketId,
    this.owner,
    this.id,
    this.updatedAt,
    this.createdAt,
    this.lastAccessedAt,
    this.metadata,
    this.buckets,
  });

  factory StorageFile.fromFileObject(FileObject file) => StorageFile(
        name: file.name,
        bucketId: file.bucketId,
        owner: file.owner,
        id: file.id,
        updatedAt: file.updatedAt,
        createdAt: file.createdAt,
        lastAccessedAt: file.lastAccessedAt,
        metadata: file.metadata,
        buckets: file.buckets,
      );

  final String name;
  final String? bucketId;
  final String? owner;
  final String? id;
  final String? updatedAt;
  final String? createdAt;
  final String? lastAccessedAt;
  final Map<String, dynamic>? metadata;
  final Bucket? buckets;

  bool get isFolder => id == null;

  String get mimeType => metadata?['mimetype'] as String? ?? '';
}
