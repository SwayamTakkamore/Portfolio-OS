import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/file_system.dart';
import '../data/file_system_data.dart';
import 'markdown_viewer.dart';

class FileExplorerWindow extends StatefulWidget {
  const FileExplorerWindow({super.key});

  @override
  State<FileExplorerWindow> createState() => _FileExplorerWindowState();
}

class _FileExplorerWindowState extends State<FileExplorerWindow> {
  List<PathItem> _navigationPath = [];
  List<FileSystemItem> _currentItems = PortfolioFileSystem.drives;
  FileSystemItem? _selectedItem;
  String _viewMode = 'list'; // 'list' or 'grid'

  @override
  void initState() {
    super.initState();
    _navigationPath.add(PathItem(name: 'This PC', items: _currentItems));
  }

  void _navigateToItem(FileSystemItem item) {
    if (item is DriveItem) {
      setState(() {
        _currentItems = item.children;
        _navigationPath.add(PathItem(name: item.name, items: item.children));
        _selectedItem = null;
      });
    } else if (item is FolderItem) {
      setState(() {
        _currentItems = item.children;
        _navigationPath.add(PathItem(name: item.name, items: item.children));
        _selectedItem = null;
      });
    } else if (item is FileItem) {
      _openFile(item);
    }
  }

  void _navigateToPath(int index) {
    if (index < _navigationPath.length - 1) {
      setState(() {
        _navigationPath = _navigationPath.sublist(0, index + 1);
        _currentItems = _navigationPath.last.items;
        _selectedItem = null;
      });
    }
  }

  void _goBack() {
    if (_navigationPath.length > 1) {
      setState(() {
        _navigationPath.removeLast();
        _currentItems = _navigationPath.last.items;
        _selectedItem = null;
      });
    }
  }

  void _goForward() {
    // Implement forward navigation if needed
  }

  void _goUp() {
    _goBack();
  }

  void _openFile(FileItem file) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: MarkdownViewer(file: file),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildTitleBar(),
          _buildToolbar(),
          _buildAddressBar(),
          Expanded(
            child: Row(
              children: [
                _buildSidebar(),
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          ),
          _buildStatusBar(),
        ],
      ),
    );
  }

  Widget _buildTitleBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.2),
            AppColors.accent2.withOpacity(0.2),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.folder, color: AppColors.accent, size: 20),
          const SizedBox(width: 8),
          Text(
            'File Explorer',
            style: GoogleFonts.jetBrainsMono(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: AppColors.accent.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildToolbarButton(
            icon: Icons.arrow_back,
            onPressed: _navigationPath.length > 1 ? _goBack : null,
            tooltip: 'Back',
          ),
          const SizedBox(width: 4),
          _buildToolbarButton(
            icon: Icons.arrow_forward,
            onPressed: null,
            tooltip: 'Forward',
          ),
          const SizedBox(width: 4),
          _buildToolbarButton(
            icon: Icons.arrow_upward,
            onPressed: _navigationPath.length > 1 ? _goUp : null,
            tooltip: 'Up',
          ),
          const SizedBox(width: 16),
          _buildToolbarButton(
            icon: Icons.refresh,
            onPressed: () => setState(() {}),
            tooltip: 'Refresh',
          ),
          const Spacer(),
          _buildToolbarButton(
            icon: Icons.view_list,
            onPressed: () => setState(() => _viewMode = 'list'),
            tooltip: 'List View',
            isActive: _viewMode == 'list',
          ),
          const SizedBox(width: 4),
          _buildToolbarButton(
            icon: Icons.grid_view,
            onPressed: () => setState(() => _viewMode = 'grid'),
            tooltip: 'Grid View',
            isActive: _viewMode == 'grid',
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.accent.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: isActive
                ? Border.all(color: AppColors.accent.withOpacity(0.5))
                : null,
          ),
          child: Icon(
            icon,
            size: 20,
            color: onPressed == null
                ? AppColors.textSecondary.withOpacity(0.3)
                : isActive
                    ? AppColors.accent
                    : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressBar() {
    return Container(
      height: 40,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _navigationPath.length,
                  (index) => Row(
                    children: [
                      InkWell(
                        onTap: () => _navigateToPath(index),
                        child: Text(
                          _navigationPath[index].name,
                          style: GoogleFonts.jetBrainsMono(
                            color: index == _navigationPath.length - 1
                                ? AppColors.textPrimary
                                : AppColors.accent,
                            fontSize: 12,
                            fontWeight: index == _navigationPath.length - 1
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (index < _navigationPath.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            Icons.chevron_right,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        border: Border(
          right: BorderSide(
            color: AppColors.accent.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Quick Access',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          ...PortfolioFileSystem.drives.map((drive) => _buildSidebarItem(
                icon: Icons.storage,
                label: '${drive.label} (${drive.name})',
                onTap: () => _navigateToItem(drive),
              )),
        ],
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.accent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.jetBrainsMono(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (_currentItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'This folder is empty',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: _viewMode == 'list' ? _buildListView() : _buildGridView(),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _currentItems.length,
      itemBuilder: (context, index) {
        final item = _currentItems[index];
        final isSelected = _selectedItem == item;

        return InkWell(
          onTap: () => setState(() => _selectedItem = item),
          onDoubleTap: () => _navigateToItem(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isSelected
                  ? Border.all(color: AppColors.accent.withOpacity(0.5))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: _getItemColor(item),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.name,
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
                if (item is FileItem) ...[
                  Text(
                    item.formattedSize,
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                Text(
                  _formatDate(item.dateModified),
                  style: GoogleFonts.jetBrainsMono(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _currentItems.length,
      itemBuilder: (context, index) {
        final item = _currentItems[index];
        final isSelected = _selectedItem == item;

        return InkWell(
          onTap: () => setState(() => _selectedItem = item),
          onDoubleTap: () => _navigateToItem(item),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: AppColors.accent.withOpacity(0.5))
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 48,
                  color: _getItemColor(item),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    item.name,
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textPrimary,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBar() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.3),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
        border: Border(
          top: BorderSide(
            color: AppColors.accent.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '${_currentItems.length} item${_currentItems.length != 1 ? 's' : ''}',
            style: GoogleFonts.jetBrainsMono(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          if (_selectedItem != null) ...[
            const SizedBox(width: 16),
            Text(
              '${_selectedItem!.name} selected',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.accent,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getItemColor(FileSystemItem item) {
    if (item is DriveItem) return AppColors.accent;
    if (item is FolderItem) return const Color(0xFFFFD700);
    if (item is FileItem) {
      switch (item.fileType) {
        case FileType.markdown:
          return AppColors.accent2;
        case FileType.text:
          return Colors.white;
        case FileType.json:
          return Colors.green;
        case FileType.image:
          return Colors.blue;
        case FileType.pdf:
          return Colors.red;
        default:
          return AppColors.textSecondary;
      }
    }
    return AppColors.textSecondary;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
