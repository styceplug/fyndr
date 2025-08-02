import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ImageCacheService {
  static final ImageCacheService _instance = ImageCacheService._internal();
  factory ImageCacheService() => _instance;
  ImageCacheService._internal();

  // Generate a unique filename based on the URL
  String _generateFileName(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    return 'avatar_${digest.toString()}.jpg';
  }

  // Get the avatars directory
  Future<Directory> _getAvatarsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final avatarsDir = Directory('${directory.path}/avatars');

    if (!await avatarsDir.exists()) {
      await avatarsDir.create(recursive: true);
    }

    return avatarsDir;
  }

  // Cache an image from URL
  Future<File?> cacheImageFromUrl(String imageUrl) async {
    try {
      if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
        debugPrint('🛑 Invalid URL for caching: $imageUrl');
        return null;
      }

      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        return await _saveImageToCache(imageUrl, response.bodyBytes);
      } else {
        debugPrint('🛑 Failed to download image for caching: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('🛑 Error caching image from URL: $e');
      return null;
    }
  }

  // Cache an image from local file (for uploaded images)
  Future<File?> cacheImageFromFile(String imageUrl, File localFile) async {
    try {
      if (imageUrl.isEmpty || !await localFile.exists()) {
        debugPrint('🛑 Invalid parameters for file caching');
        return null;
      }

      final bytes = await localFile.readAsBytes();
      return await _saveImageToCache(imageUrl, bytes);
    } catch (e) {
      debugPrint('🛑 Error caching image from file: $e');
      return null;
    }
  }

  // Save image bytes to cache with metadata
  Future<File?> _saveImageToCache(String imageUrl, Uint8List imageBytes) async {
    try {
      final avatarsDir = await _getAvatarsDirectory();
      final fileName = _generateFileName(imageUrl);
      final file = File('${avatarsDir.path}/$fileName');
      final metaFile = File('${avatarsDir.path}/${fileName}_meta.txt');

      // Save the image
      await file.writeAsBytes(imageBytes);

      // Save metadata (URL) to track which URL this cached file represents
      await metaFile.writeAsString(imageUrl);

      debugPrint('✅ Image cached successfully: ${file.path}');
      return file;
    } catch (e) {
      debugPrint('🛑 Error saving image to cache: $e');
      return null;
    }
  }

  // Get cached image file if it exists and is valid
  Future<File?> getCachedImage(String imageUrl) async {
    try {
      if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
        return null;
      }

      final avatarsDir = await _getAvatarsDirectory();
      final fileName = _generateFileName(imageUrl);
      final cachedFile = File('${avatarsDir.path}/$fileName');
      final metaFile = File('${avatarsDir.path}/${fileName}_meta.txt');

      // Check if cached file exists
      if (await cachedFile.exists() && await metaFile.exists()) {
        // Verify the URL matches
        final cachedUrl = await metaFile.readAsString();
        if (cachedUrl == imageUrl) {
          return cachedFile;
        }
      }

      return null;
    } catch (e) {
      debugPrint('🛑 Error getting cached image: $e');
      return null;
    }
  }

  // Check if image is already cached
  Future<bool> isImageCached(String imageUrl) async {
    final cachedFile = await getCachedImage(imageUrl);
    return cachedFile != null;
  }

  // Clear all cached images
  Future<void> clearCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final avatarsDir = Directory('${directory.path}/avatars');

      if (await avatarsDir.exists()) {
        await avatarsDir.delete(recursive: true);
        debugPrint('✅ Image cache cleared');
      }
    } catch (e) {
      debugPrint('🛑 Error clearing cache: $e');
    }
  }

  // Remove specific cached image
  Future<void> removeCachedImage(String imageUrl) async {
    try {
      final avatarsDir = await _getAvatarsDirectory();
      final fileName = _generateFileName(imageUrl);
      final cachedFile = File('${avatarsDir.path}/$fileName');
      final metaFile = File('${avatarsDir.path}/${fileName}_meta.txt');

      if (await cachedFile.exists()) {
        await cachedFile.delete();
      }
      if (await metaFile.exists()) {
        await metaFile.delete();
      }

      debugPrint('✅ Cached image removed: $imageUrl');
    } catch (e) {
      debugPrint('🛑 Error removing cached image: $e');
    }
  }
}