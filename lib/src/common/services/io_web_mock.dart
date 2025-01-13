import 'dart:typed_data';

class FileCompat {
  FileCompat(this.path, [this.checksum]);
  final String path;
  final String? checksum;

  Future<Uint8List?> cachedBytes() => Future.value();

  Future<void> cacheFile(Uint8List bytes) async {}
}
