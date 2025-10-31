import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class RecycleBinWidget extends StatefulWidget {
  const RecycleBinWidget({super.key});

  @override
  State<RecycleBinWidget> createState() => _RecycleBinWidgetState();
}

class _RecycleBinWidgetState extends State<RecycleBinWidget> {
  final List<Map<String, dynamic>> _deletedItems = [
    {
      'icon': Icons.text_snippet,
      'name': 'Old Resume v2.pdf',
      'originalLocation': 'C:\\Users\\Documents',
      'dateDeleted': 'Oct 21, 2025 3:45 PM',
      'size': '245 KB',
    },
    {
      'icon': Icons.image,
      'name': 'temp_screenshot.png',
      'originalLocation': 'C:\\Users\\Pictures',
      'dateDeleted': 'Oct 20, 2025 10:20 AM',
      'size': '1.2 MB',
    },
    {
      'icon': Icons.folder,
      'name': 'Old Projects',
      'originalLocation': 'C:\\Users\\Desktop',
      'dateDeleted': 'Oct 18, 2025 2:15 PM',
      'size': '45 items',
    },
    {
      'icon': Icons.code,
      'name': 'test.js',
      'originalLocation': 'C:\\Projects',
      'dateDeleted': 'Oct 15, 2025 4:30 PM',
      'size': '12 KB',
    },
  ];

  Set<int> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPrimary,
      child: Column(
        children: [
          // Toolbar
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.bgPanel.withOpacity(0.5),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.accent.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppColors.accent2,
                ),
                const SizedBox(width: 12),
                Text(
                  'Recycle Bin',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (_selectedItems.isNotEmpty) ...[
                  _buildActionButton(
                    icon: Icons.restore,
                    label: 'Restore',
                    onTap: _restoreSelected,
                  ),
                  const SizedBox(width: 8),
                  _buildActionButton(
                    icon: Icons.delete_forever,
                    label: 'Delete Permanently',
                    onTap: _deleteSelected,
                    isDestructive: true,
                  ),
                ] else ...[
                  _buildActionButton(
                    icon: Icons.delete_sweep,
                    label: 'Empty Recycle Bin',
                    onTap: _emptyRecycleBin,
                    isDestructive: true,
                  ),
                ],
              ],
            ),
          ),
          // Content area
          Expanded(
            child: _deletedItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _deletedItems.length,
                    itemBuilder: (context, index) {
                      return _buildDeletedItem(index);
                    },
                  ),
          ),
          // Status bar
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.bgPanel.withOpacity(0.5),
              border: Border(
                top: BorderSide(
                  color: AppColors.accent.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '${_deletedItems.length} items in Recycle Bin',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                if (_selectedItems.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Text(
                    '${_selectedItems.length} selected',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.delete_outline,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Recycle Bin is empty',
            style: GoogleFonts.jetBrainsMono(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Deleted items will appear here',
            style: GoogleFonts.jetBrainsMono(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.error.withOpacity(0.1)
              : AppColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isDestructive
                ? AppColors.error.withOpacity(0.5)
                : AppColors.accent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isDestructive ? AppColors.error : AppColors.accent,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                color: isDestructive ? AppColors.error : AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeletedItem(int index) {
    final item = _deletedItems[index];
    final isSelected = _selectedItems.contains(index);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedItems.remove(index);
          } else {
            _selectedItems.add(index);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withOpacity(0.2)
              : AppColors.bgPanel.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.accent.withOpacity(0.5)
                : AppColors.accent.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.bgPrimary,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColors.accent,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: AppColors.bgPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                item['icon'],
                color: AppColors.error,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Original location: ${item['originalLocation']}',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        'Deleted: ${item['dateDeleted']}',
                        style: GoogleFonts.jetBrainsMono(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        item['size'],
                        style: GoogleFonts.jetBrainsMono(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _restoreSelected() {
    setState(() {
      // Remove selected items (restore them)
      final indicesToRemove = _selectedItems.toList()
        ..sort((a, b) => b.compareTo(a));
      for (var index in indicesToRemove) {
        _deletedItems.removeAt(index);
      }
      _selectedItems.clear();
    });

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Items restored successfully',
          style: GoogleFonts.jetBrainsMono(),
        ),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteSelected() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgPanel,
        title: Text(
          'Delete Permanently?',
          style: GoogleFonts.jetBrainsMono(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This action cannot be undone. The selected items will be permanently deleted.',
          style: GoogleFonts.jetBrainsMono(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                final indicesToRemove = _selectedItems.toList()
                  ..sort((a, b) => b.compareTo(a));
                for (var index in indicesToRemove) {
                  _deletedItems.removeAt(index);
                }
                _selectedItems.clear();
              });
            },
            child: Text(
              'Delete',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _emptyRecycleBin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgPanel,
        title: Text(
          'Empty Recycle Bin?',
          style: GoogleFonts.jetBrainsMono(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This will permanently delete all ${_deletedItems.length} items. This action cannot be undone.',
          style: GoogleFonts.jetBrainsMono(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _deletedItems.clear();
                _selectedItems.clear();
              });
            },
            child: Text(
              'Empty',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
