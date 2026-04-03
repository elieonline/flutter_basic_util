import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'loggers.dart';

/// Caches remote media files in temporary storage.
class MediaCache {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ),
  );

  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'];

  static const List<String> videoExtensions = [
    'mp4',
    'mov',
    'avi',
    'mkv',
    'webm',
    'flv',
    'm4v',
    '3gp',
  ];

  /// Downloads media once and returns its local path.
  static Future<String?> downloadAndCacheMedia(
    String mediaUrl, {
    String? cacheSubdirectory,
    String? fileNamePrefix,
  }) async {
    try {
      final mediaType = _getMediaType(mediaUrl);
      final extension = _extractExtension(mediaUrl, mediaType);
      final cacheDirectory = await _getCacheDirectory(cacheSubdirectory);
      final prefix = fileNamePrefix ?? 'media';
      final file = File('${cacheDirectory!.path}/${_buildFileName(mediaUrl, prefix, extension)}');

      if (await file.exists()) {
        return file.path;
      }

      debugLog('Downloading ${mediaType.name} from: $mediaUrl');
      final response = await _dio.get<List<int>>(
        mediaUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = response.data;
      if (response.statusCode == 200 && bytes != null && bytes.isNotEmpty) {
        await file.writeAsBytes(bytes, flush: true);
        return file.path;
      }

      debugLog(
        'Failed to download ${mediaType.name}. '
        'Status: ${response.statusCode}, bytes: ${bytes?.length ?? 0}',
      );
      return null;
    } on DioException catch (e) {
      debugLog('Dio error downloading media: ${e.type} ${e.message}');
      return null;
    } catch (e) {
      debugLog('Error downloading media: $e');
      return null;
    }
  }

  /// Image-only convenience wrapper.
  static Future<String?> downloadAndCacheImage(
    String imageUrl, {
    String? cacheSubdirectory,
    String? fileNamePrefix,
  }) {
    return downloadAndCacheMedia(
      imageUrl,
      cacheSubdirectory: cacheSubdirectory ?? 'image_cache',
      fileNamePrefix: fileNamePrefix ?? 'image',
    );
  }

  /// Video-only convenience wrapper.
  static Future<String?> downloadAndCacheVideo(
    String videoUrl, {
    String? cacheSubdirectory,
    String? fileNamePrefix,
  }) {
    return downloadAndCacheMedia(
      videoUrl,
      cacheSubdirectory: cacheSubdirectory ?? 'video_cache',
      fileNamePrefix: fileNamePrefix ?? 'video',
    );
  }

  /// Returns true if URL extension matches an image type.
  static bool isImageUrl(String url) => _getMediaType(url) == MediaType.image;

  /// Returns true if URL extension matches a video type.
  static bool isVideoUrl(String url) => _getMediaType(url) == MediaType.video;

  /// Deletes cache files and returns deleted count.
  static Future<int> clearCache({String? cacheSubdirectory, Duration? olderThan}) async {
    try {
      final cacheDirectory = await _getCacheDirectory(cacheSubdirectory, createIfMissing: false);
      if (cacheDirectory == null) {
        return 0;
      }

      int deletedCount = 0;
      final now = DateTime.now();

      await for (final entity in cacheDirectory.list()) {
        if (entity is! File) {
          continue;
        }

        var shouldDelete = true;
        if (olderThan != null) {
          final stat = await entity.stat();
          shouldDelete = now.difference(stat.modified) > olderThan;
        }

        if (!shouldDelete) {
          continue;
        }

        try {
          await entity.delete();
          deletedCount++;
        } catch (e) {
          debugLog('Error deleting cached file ${entity.path}: $e');
        }
      }

      return deletedCount;
    } catch (e) {
      debugLog('Error clearing cache: $e');
      return 0;
    }
  }

  /// Returns cached path if present, otherwise null.
  static Future<String?> getCachedMediaPath(
    String mediaUrl, {
    String? cacheSubdirectory,
    String? fileNamePrefix,
  }) async {
    try {
      final mediaType = _getMediaType(mediaUrl);
      final extension = _extractExtension(mediaUrl, mediaType);
      final cacheDirectory = await _getCacheDirectory(cacheSubdirectory, createIfMissing: false);
      if (cacheDirectory == null) {
        return null;
      }

      final prefix = fileNamePrefix ?? 'media';
      final file = File('${cacheDirectory.path}/${_buildFileName(mediaUrl, prefix, extension)}');

      return await file.exists() ? file.path : null;
    } catch (e) {
      debugLog('Error getting cached media path: $e');
      return null;
    }
  }

  /// Returns cache folder size in bytes.
  static Future<int> getCacheSize({String? cacheSubdirectory}) async {
    try {
      final cacheDirectory = await _getCacheDirectory(cacheSubdirectory, createIfMissing: false);
      if (cacheDirectory == null) {
        return 0;
      }

      int totalSize = 0;
      await for (final entity in cacheDirectory.list()) {
        if (entity is! File) {
          continue;
        }
        try {
          totalSize += await entity.length();
        } catch (e) {
          debugLog('Error getting file size ${entity.path}: $e');
        }
      }

      return totalSize;
    } catch (e) {
      debugLog('Error getting cache size: $e');
      return 0;
    }
  }

  static MediaType _getMediaType(String url) {
    final extension = _extractExtension(url, MediaType.unknown);
    if (imageExtensions.contains(extension)) {
      return MediaType.image;
    }
    if (videoExtensions.contains(extension)) {
      return MediaType.video;
    }
    return MediaType.image;
  }

  static String _extractExtension(String url, MediaType mediaType) {
    try {
      final uri = Uri.parse(url);
      final lastSegment = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
      if (lastSegment.contains('.')) {
        return lastSegment.split('.').last.toLowerCase();
      }
    } catch (e) {
      debugLog('Error extracting extension: $e');
    }
    return mediaType == MediaType.video ? 'mp4' : 'jpg';
  }

  static String _buildFileName(String mediaUrl, String prefix, String extension) {
    final hash = sha256.convert(utf8.encode(mediaUrl)).toString();
    return '${prefix}_$hash.$extension';
  }

  static Future<Directory?> _getCacheDirectory(
    String? cacheSubdirectory, {
    bool createIfMissing = true,
  }) async {
    final cacheDir = await getTemporaryDirectory();
    final folderName = cacheSubdirectory ?? 'media_cache';
    final directory = Directory('${cacheDir.path}/$folderName');

    if (await directory.exists()) {
      return directory;
    }
    if (!createIfMissing) {
      return null;
    }

    await directory.create(recursive: true);
    return directory;
  }
}

enum MediaType { image, video, unknown }
