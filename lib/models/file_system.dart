import 'package:flutter/material.dart';

/// Represents different types of file system items
enum FileSystemItemType {
  drive,
  folder,
  file,
}

/// Represents file types
enum FileType {
  markdown,
  text,
  json,
  image,
  pdf,
  unknown,
}

/// Base class for all file system items
abstract class FileSystemItem {
  final String name;
  final FileSystemItemType type;
  final IconData icon;
  final DateTime dateCreated;
  final DateTime dateModified;

  FileSystemItem({
    required this.name,
    required this.type,
    required this.icon,
    DateTime? dateCreated,
    DateTime? dateModified,
  })  : dateCreated = dateCreated ?? DateTime.now(),
        dateModified = dateModified ?? DateTime.now();
}

/// Represents a file in the file system
class FileItem extends FileSystemItem {
  final String content;
  final FileType fileType;
  final String extension;
  final int size; // in bytes
  final String? assetPath; // Path to asset file for lazy loading

  FileItem({
    required String name,
    required this.content,
    required this.fileType,
    required this.extension,
    this.assetPath,
    DateTime? dateCreated,
    DateTime? dateModified,
  })  : size = content.isEmpty && assetPath != null ? 1024 : content.length,
        super(
          name: name,
          type: FileSystemItemType.file,
          icon: _getIconForFileType(fileType),
          dateCreated: dateCreated,
          dateModified: dateModified,
        );

  static IconData _getIconForFileType(FileType type) {
    switch (type) {
      case FileType.markdown:
        return Icons.description;
      case FileType.text:
        return Icons.text_snippet;
      case FileType.json:
        return Icons.code;
      case FileType.image:
        return Icons.image;
      case FileType.pdf:
        return Icons.picture_as_pdf;
      case FileType.unknown:
        return Icons.insert_drive_file;
    }
  }

  static FileType getFileTypeFromExtension(String ext) {
    switch (ext.toLowerCase()) {
      case '.md':
      case '.markdown':
        return FileType.markdown;
      case '.txt':
        return FileType.text;
      case '.json':
        return FileType.json;
      case '.png':
      case '.jpg':
      case '.jpeg':
      case '.gif':
        return FileType.image;
      case '.pdf':
        return FileType.pdf;
      default:
        return FileType.unknown;
    }
  }

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Represents a folder in the file system
class FolderItem extends FileSystemItem {
  final List<FileSystemItem> children;

  FolderItem({
    required String name,
    required this.children,
    DateTime? dateCreated,
    DateTime? dateModified,
  }) : super(
          name: name,
          type: FileSystemItemType.folder,
          icon: Icons.folder,
          dateCreated: dateCreated,
          dateModified: dateModified,
        );

  int get itemCount => children.length;
}

/// Represents a drive in the file system
class DriveItem extends FileSystemItem {
  final List<FileSystemItem> children;
  final String label;
  final String totalSpace;
  final String usedSpace;
  final String freeSpace;

  DriveItem({
    required String name,
    required this.label,
    required this.children,
    this.totalSpace = '100 GB',
    this.usedSpace = '45 GB',
    this.freeSpace = '55 GB',
    DateTime? dateCreated,
    DateTime? dateModified,
  }) : super(
          name: name,
          type: FileSystemItemType.drive,
          icon: Icons.storage,
          dateCreated: dateCreated,
          dateModified: dateModified,
        );

  int get itemCount => children.length;
}

/// Navigation path item for breadcrumb
class PathItem {
  final String name;
  final List<FileSystemItem> items;

  PathItem({
    required this.name,
    required this.items,
  });
}
