// ignore_for_file: comment_references, avoid_positional_boolean_parameters, prefer_foreach, lines_longer_than_80_chars

import 'dart:async';
import 'dart:developer';
import 'package:base_starter/src/common/services/io_web_mock.dart'
    if (dart.library.io) 'package:base_starter/src/common/services/io_web_mock.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

/// Describes the remote font asset with the given [url] and optional
/// [checksum] (md5sum or sha256sum) to verify the cached font file.
/// If [checksum] is not provided, the font file will **never** be cached.
class RemoteFontAsset {
  /// Creates a new [RemoteFontAsset] with the given [url] and optional
  /// [checksum].
  ///
  /// @param url The [url] of the remote font file.
  /// @param checksum The md5sum or sha256sum of the remote font file.
  const RemoteFontAsset(this.url, [this.checksum]) : assert(checksum != '');

  /// The url of the remote font file.
  final String url;

  /// The checksum (md5sum or sha256sum) of the remote font file.
  final String? checksum;

  Uri get _uri => Uri.parse(url);

  Future<Uint8List> get _remoteBytes async {
    final httpClient = http.Client();
    final bytes = (await httpClient.get(_uri)).bodyBytes;
    httpClient.close();
    return bytes;
  }

  /// Returns the font data as `Future<ByteData>`.
  /// If [cacheDirPath] is provided, the font file will be cached in the
  /// [cacheDirPath] directory and the [checksum] will be used as file name.
  ///
  /// @param cacheDirPath The path to the cache directory.
  /// @returns The font data as `Future<ByteData>`.
  Future<ByteData> getFont([FutureOr<String?>? cacheDirPath]) async {
    final cachePath = await cacheDirPath;
    if (cachePath != null && checksum == null) {
      throw ArgumentError('When cacheDirPath is provided, checksum must be'
          ' provided as well.');
    }
    if (checksum != null && checksum!.length != 32 && checksum!.length != 64) {
      throw ArgumentError('Checksum must be md5sum or sha256sum.');
    }

    FileCompat? localFile;
    if (cachePath != null) {
      final localFilePath =
          path.join(cachePath, '$checksum${path.extension(url)}');
      localFile = FileCompat(localFilePath, checksum);
      final localBytes = await localFile.cachedBytes();
      if (localBytes != null) {
        return ByteData.view(localBytes.buffer);
      }
    }
    final remoteBytes = await _remoteBytes;
    if (localFile != null) {
      await localFile.cacheFile(remoteBytes);
    }
    return ByteData.view(remoteBytes.buffer);
  }
}

/// Describes the remote font with the given [family] name and [assets] list.
/// The [assets] list contains the font files for the given [family] name.
/// The [assets] list can contain multiple font files for different font
/// weights and styles.
/// The [cacheDirPath] is optional and will be used to cache the font files.
/// If [cacheDirPath] is not provided, the font files will **never** be cached.
/// The [cacheDirPath] can be provided for example by the
/// [path_provider](https://pub.dev/packages/path_provider) package.
class RemoteFont {
  /// Creates a new [RemoteFont] with the given [family] name and [assets] list.
  /// The [assets] list contains the font files for the given [family] name.
  /// The [assets] list can contain multiple font files for different font
  /// weights and styles.
  /// The [cacheDirPath] is optional and will be used to cache the font files.
  /// If [cacheDirPath] is not provided, the font files will never be cached.
  /// The [cacheDirPath] can be provided for example by the
  /// [path_provider](https://pub.dev/packages/path_provider) package.
  ///
  /// @param family The family name of the remote font.
  /// @param assets The list of remote font assets.
  /// @param cacheDirPath The path to the cache directory. Optional.
  const RemoteFont({
    required this.family,
    required this.assets,
    this.cacheDirPath,
  });

  /// The family name of the remote font.
  final String family;

  /// The list of remote font assets.
  final Iterable<RemoteFontAsset> assets;

  /// The path to the cache directory. Optional.
  /// If [cacheDirPath] is not provided, the font files will never be cached.
  final FutureOr<String?>? cacheDirPath;

  /// Returns the font data as `Iterable<Future<ByteData>>`.
  Iterable<Future<ByteData>> loadableFonts() =>
      assets.map((asset) => asset.getFont(cacheDirPath));
}

/// Loader class for the given [RemoteFont]s.
/// The [RemoteFont]s will be cached if [cacheDirPath] and [checksum] is
/// provided for the [RemoteFont] and [RemoteFontAsset]s respectively.
abstract class RemoteFontsLoader {
  static final List<String> _loadedFonts = [];

  /// Loads the given [fonts] list.
  /// If [parallel] is true, the [fonts] will be loaded in parallel.
  /// Otherwise, the [fonts] will be loaded sequentially.
  static Future<void> load(
    Iterable<RemoteFont> fonts, [
    bool parallel = false,
  ]) async {
    if (parallel) {
      await Future.wait(fonts.map(_loadFont));
    } else {
      for (final font in fonts) {
        await _loadFont(font);
      }
    }
  }

  static Future<void> _loadFont(RemoteFont font) async {
    if (_loadedFonts.contains(font.family)) {
      return log(
        'WARNING: Font ${font.family} is already loaded.',
        name: 'RemoteFontsLoader',
        level: 900,
      );
    }
    _loadedFonts.add(font.family);
    final assets = font.loadableFonts();
    final fontLoader = FontLoader(font.family);
    for (final fontData in assets) {
      fontLoader.addFont(fontData);
    }
    await fontLoader.load();
  }
}
