import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/henna_models.dart';
import '../models/mehndi_design.dart';
import '../models/favorites_collection.dart';
import '../models/downloaded_design.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();

  factory CacheService() {
    return _instance;
  }

  CacheService._internal();

  // Cache duration (hourly)
  static const Duration cacheDuration = Duration(hours: 1);

  // Initialize cache directory
  Future<Directory> get _cacheDir async {
    final baseDir = await getApplicationCacheDirectory();
    final cacheDir = Directory('${baseDir.path}/henna_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  // Cache categories
  Future<bool> cacheCategories(List<HennaCategory> categories) async {
    try {
      final cacheDir = await _cacheDir;
      final file = File('${cacheDir.path}/categories.json');
      
      final jsonList = categories.map((c) => c.toJson()).toList();
      final metadata = {
        'cachedAt': DateTime.now().toIso8601String(),
        'nextUpdateTime': 
            DateTime.now().add(cacheDuration).toIso8601String(),
        'count': jsonList.length,
      };

      final combined = {
        'metadata': metadata,
        'data': jsonList,
      };

      await file.writeAsString(jsonEncode(combined));
      return true;
    } catch (e) {
      print('Error caching categories: $e');
      return false;
    }
  }

  // Load cached categories
  Future<List<HennaCategory>?> loadCachedCategories() async {
    try {
      final cacheDir = await _cacheDir;
      final file = File('${cacheDir.path}/categories.json');

      if (!await file.exists()) {
        return null;
      }

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      
      // Check if cache is outdated
      final metadata = json['metadata'] as Map<String, dynamic>;
      final nextUpdateTime = 
          DateTime.parse(metadata['nextUpdateTime'] as String);
      
      if (DateTime.now().isAfter(nextUpdateTime)) {
        // Cache outdated
        return null;
      }

      final dataList = json['data'] as List;
      return dataList
          .map((item) => HennaCategory.fromJson(item))
          .toList();
    } catch (e) {
      print('Error loading cached categories: $e');
      return null;
    }
  }

  // Cache images for a category
  Future<bool> cacheImagesForCategory(
    String categoryId,
    List<HennaImage> images,
  ) async {
    try {
      final cacheDir = await _cacheDir;
      final file = File('${cacheDir.path}/images_$categoryId.json');

      final jsonList = images.map((img) => img.toJson()).toList();
      final metadata = {
        'categoryId': categoryId,
        'cachedAt': DateTime.now().toIso8601String(),
        'nextUpdateTime':
            DateTime.now().add(cacheDuration).toIso8601String(),
        'count': jsonList.length,
      };

      final combined = {
        'metadata': metadata,
        'data': jsonList,
      };

      await file.writeAsString(jsonEncode(combined));
      return true;
    } catch (e) {
      print('Error caching images: $e');
      return false;
    }
  }

  // Load cached images for a category
  Future<List<HennaImage>?> loadCachedImagesForCategory(
    String categoryId,
  ) async {
    try {
      final cacheDir = await _cacheDir;
      final file = File('${cacheDir.path}/images_$categoryId.json');

      if (!await file.exists()) {
        return null;
      }

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;

      // Check if cache is outdated
      final metadata = json['metadata'] as Map<String, dynamic>;
      final nextUpdateTime =
          DateTime.parse(metadata['nextUpdateTime'] as String);

      if (DateTime.now().isAfter(nextUpdateTime)) {
        // Cache outdated
        return null;
      }

      final dataList = json['data'] as List;
      return dataList.map((item) => HennaImage.fromJson(item)).toList();
    } catch (e) {
      print('Error loading cached images: $e');
      return null;
    }
  }

  // Check if cache is outdated
  Future<bool> isCachOutdated(String categoryId) async {
    try {
      final cacheDir = await _cacheDir;
      final file = File('${cacheDir.path}/images_$categoryId.json');

      if (!await file.exists()) {
        return true;
      }

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;

      final metadata = json['metadata'] as Map<String, dynamic>;
      final nextUpdateTime =
          DateTime.parse(metadata['nextUpdateTime'] as String);

      return DateTime.now().isAfter(nextUpdateTime);
    } catch (e) {
      print('Error checking cache: $e');
      return true;
    }
  }

  // Get cache metadata
  Future<CachedImagesMetadata?> getCacheMetadata(String categoryId) async {
    try {
      final cacheDir = await _cacheDir;
      final file = File('${cacheDir.path}/images_$categoryId.json');

      if (!await file.exists()) {
        return null;
      }

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;

      final metadata = json['metadata'] as Map<String, dynamic>;
      return CachedImagesMetadata.fromJson(metadata);
    } catch (e) {
      print('Error getting cache metadata: $e');
      return null;
    }
  }

  // Clear specific category cache
  Future<bool> clearCategoryCache(String categoryId) async {
    try {
      final cacheDir = await _cacheDir;
      final file = File('${cacheDir.path}/images_$categoryId.json');

      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      print('Error clearing category cache: $e');
      return false;
    }
  }

  // Clear all cache
  Future<bool> clearAllCache() async {
    try {
      final cacheDir = await _cacheDir;
      await cacheDir.delete(recursive: true);
      return true;
    } catch (e) {
      print('Error clearing all cache: $e');
      return false;
    }
  }

  // Get cache size
  Future<int> getCacheSize() async {
    try {
      final cacheDir = await _cacheDir;
      if (!await cacheDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      final files = cacheDir.listSync(recursive: true);
      for (var file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }
      return totalSize;
    } catch (e) {
      print('Error calculating cache size: $e');
      return 0;
    }
  }
}
