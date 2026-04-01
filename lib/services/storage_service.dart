import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/favorites_collection.dart';
import '../models/downloaded_design.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();

  // Initialize storage
  Future<Directory> get _mehndiDir async {
    final baseDir = await getApplicationDocumentsDirectory();
    final mehndiDir = Directory('${baseDir.path}/mehndi');
    if (!await mehndiDir.exists()) {
      await mehndiDir.create(recursive: true);
    }
    return mehndiDir;
  }

  // Save favorite designs locally
  Future<bool> saveFavorites(List<String> favoriteIds) async {
    try {
      final mehndiDir = await _mehndiDir;
      final file = File('${mehndiDir.path}/favorites.json');
      await file.writeAsString(jsonEncode({'favorites': favoriteIds}));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Load favorite designs
  Future<List<String>> loadFavorites() async {
    try {
      final mehndiDir = await _mehndiDir;
      final file = File('${mehndiDir.path}/favorites.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final json = jsonDecode(content);
        return List<String>.from(json['favorites'] ?? []);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Save favorite collections
  Future<bool> saveFavoriteCollections(
      List<FavoriteCollection> collections) async {
    try {
      final mehndiDir = await _mehndiDir;
      final file = File('${mehndiDir.path}/collections.json');
      final jsonList = collections.map((c) => c.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Load favorite collections
  Future<List<FavoriteCollection>> loadFavoriteCollections() async {
    try {
      final mehndiDir = await _mehndiDir;
      final file = File('${mehndiDir.path}/collections.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonList = jsonDecode(content) as List;
        return jsonList
            .map((json) => FavoriteCollection.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Save downloaded design info
  Future<bool> saveDownloadedDesignInfo(DownloadedDesign design) async {
    try {
      final mehndiDir = await _mehndiDir;
      final file = File('${mehndiDir.path}/downloads_info.json');

      List<DownloadedDesign> downloads = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonList = jsonDecode(content) as List;
        downloads = jsonList
            .map((json) => DownloadedDesign.fromJson(json))
            .toList();
      }

      // Add or update
      final index = downloads.indexWhere((d) => d.id == design.id);
      if (index >= 0) {
        downloads[index] = design;
      } else {
        downloads.add(design);
      }

      final jsonList = downloads.map((d) => d.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Load downloaded designs info
  Future<List<DownloadedDesign>> loadDownloadedDesigns() async {
    try {
      final mehndiDir = await _mehndiDir;
      final file = File('${mehndiDir.path}/downloads_info.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonList = jsonDecode(content) as List;
        return jsonList
            .map((json) => DownloadedDesign.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Delete downloaded design
  Future<bool> deleteDownloadedDesign(String designId) async {
    try {
      final downloads = await loadDownloadedDesigns();
      final index = downloads.indexWhere((d) => d.designId == designId);
      if (index == -1) return false;

      final design = downloads[index];

      // Delete file
      final file = File(design.localPath);
      if (await file.exists()) {
        await file.delete();
      }

      // Update info
      downloads.removeAt(index);
      final mehndiDir = await _mehndiDir;
      final infoFile = File('${mehndiDir.path}/downloads_info.json');
      final jsonList = downloads.map((d) => d.toJson()).toList();
      await infoFile.writeAsString(jsonEncode(jsonList));

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get total downloads size
  Future<int> getTotalDownloadsSize() async {
    try {
      final downloads = await loadDownloadedDesigns();
      return downloads.fold<int>(0, (sum, design) => sum + design.fileSizeInBytes);
    } catch (e) {
      return 0;
    }
  }

  // Clear all data
  Future<bool> clearAllData() async {
    try {
      final mehndiDir = await _mehndiDir;
      if (await mehndiDir.exists()) {
        await mehndiDir.delete(recursive: true);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
