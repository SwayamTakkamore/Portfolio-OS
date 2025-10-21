import 'package:flutter/services.dart';
import '../models/file_system.dart';

/// Helper class to create FileItems from asset files
class FileSystemHelper {
  /// Creates a FileItem that loads content from an asset file
  static FileItem createAssetFile({
    required String name,
    required String assetPath,
    required String extension,
    required FileType fileType,
  }) {
    return FileItem(
      name: name,
      extension: extension,
      fileType: fileType,
      content: '', // Will be loaded on demand
      assetPath: assetPath, // Store the path for lazy loading
    );
  }

  /// Loads the actual content from an asset file
  static Future<String> loadAssetContent(String assetPath) async {
    try {
      return await rootBundle.loadString(assetPath);
    } catch (e) {
      return 'Error loading file: $e';
    }
  }
}
