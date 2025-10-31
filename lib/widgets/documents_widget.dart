import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class DocumentsWidget extends StatelessWidget {
  const DocumentsWidget({super.key});

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
                _buildToolbarButton(Icons.arrow_back, 'Back'),
                const SizedBox(width: 8),
                _buildToolbarButton(Icons.arrow_forward, 'Forward'),
                const SizedBox(width: 8),
                _buildToolbarButton(Icons.arrow_upward, 'Up'),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.bgPrimary,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 16,
                          color: AppColors.accent2,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Documents',
                          style: GoogleFonts.jetBrainsMono(
                            color: AppColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildToolbarButton(Icons.search, 'Search'),
                const SizedBox(width: 8),
                _buildToolbarButton(Icons.view_list, 'List View'),
              ],
            ),
          ),
          // Content area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildFolderItem(
                  icon: Icons.text_snippet,
                  name: 'Resume.pdf',
                  size: '245 KB',
                  modified: 'Oct 20, 2025',
                ),
                _buildFolderItem(
                  icon: Icons.image,
                  name: 'Portfolio Screenshots',
                  size: '12 items',
                  modified: 'Oct 18, 2025',
                  isFolder: true,
                ),
                _buildFolderItem(
                  icon: Icons.code,
                  name: 'Projects',
                  size: '8 items',
                  modified: 'Oct 15, 2025',
                  isFolder: true,
                ),
                _buildFolderItem(
                  icon: Icons.description,
                  name: 'Cover Letter.docx',
                  size: '156 KB',
                  modified: 'Oct 10, 2025',
                ),
                _buildFolderItem(
                  icon: Icons.folder,
                  name: 'Certificates',
                  size: '15 items',
                  modified: 'Oct 5, 2025',
                  isFolder: true,
                ),
                _buildFolderItem(
                  icon: Icons.picture_as_pdf,
                  name: 'Technical Skills.pdf',
                  size: '189 KB',
                  modified: 'Sep 28, 2025',
                ),
                _buildFolderItem(
                  icon: Icons.folder,
                  name: 'Work Samples',
                  size: '24 items',
                  modified: 'Sep 20, 2025',
                  isFolder: true,
                ),
                _buildFolderItem(
                  icon: Icons.text_snippet,
                  name: 'References.txt',
                  size: '4 KB',
                  modified: 'Sep 15, 2025',
                ),
              ],
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
                  '8 items',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '1.2 MB total',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFolderItem({
    required IconData icon,
    required String name,
    required String size,
    required String modified,
    bool isFolder = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgPanel.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isFolder
                  ? AppColors.accent2.withOpacity(0.2)
                  : AppColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: isFolder ? AppColors.accent2 : AppColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      size,
                      style: GoogleFonts.jetBrainsMono(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      modified,
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
          Icon(
            Icons.more_vert,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
