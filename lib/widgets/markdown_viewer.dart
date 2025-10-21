import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../models/file_system.dart';

class MarkdownViewer extends StatefulWidget {
  final FileItem file;

  const MarkdownViewer({super.key, required this.file});

  @override
  State<MarkdownViewer> createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  String _content = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      String content;
      if (widget.file.assetPath != null && widget.file.assetPath!.isNotEmpty) {
        // Load from asset file
        content = await rootBundle.loadString(widget.file.assetPath!);
      } else {
        // Use hardcoded content
        content = widget.file.content;
      }

      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading file: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 600,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27).withOpacity(0.98),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTitleBar(context),
          _buildToolbar(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.3),
            AppColors.accent2.withOpacity(0.3),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(Icons.description, color: AppColors.accent2, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.file.name,
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: AppColors.textSecondary,
            onPressed: () => Navigator.pop(context),
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27).withOpacity(0.5),
        border: Border(
          bottom: BorderSide(
            color: AppColors.accent.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getIconForFileType(widget.file.fileType),
            size: 16,
            color: AppColors.accent2,
          ),
          const SizedBox(width: 8),
          Text(
            widget.file.extension.toUpperCase(),
            style: GoogleFonts.jetBrainsMono(
              color: AppColors.accent2,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 20,
            color: AppColors.accent.withOpacity(0.3),
          ),
          const SizedBox(width: 16),
          Text(
            widget.file.formattedSize,
            style: GoogleFonts.jetBrainsMono(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const Spacer(),
          _buildToolbarButton(
            icon: Icons.copy,
            label: 'Copy',
            onTap: () {
              Clipboard.setData(ClipboardData(text: _content));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: AppColors.accent),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.textPrimary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.accent,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.error,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Markdown(
        data: _content,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          // Headings
          h1: GoogleFonts.jetBrainsMono(
            color: AppColors.accent2,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
          h2: GoogleFonts.jetBrainsMono(
            color: AppColors.accent2,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
          h3: GoogleFonts.jetBrainsMono(
            color: AppColors.accent,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          h4: GoogleFonts.jetBrainsMono(
            color: AppColors.accent,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          h5: GoogleFonts.jetBrainsMono(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          h6: GoogleFonts.jetBrainsMono(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          // Body text
          p: GoogleFonts.jetBrainsMono(
            color: AppColors.textPrimary,
            fontSize: 14,
            height: 1.8,
          ),
          // Lists
          listBullet: GoogleFonts.jetBrainsMono(
            color: AppColors.accent,
            fontSize: 14,
          ),
          // Links
          a: GoogleFonts.jetBrainsMono(
            color: AppColors.accent2,
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
          // Code
          code: GoogleFonts.jetBrainsMono(
            color: AppColors.accent2,
            fontSize: 13,
            backgroundColor: AppColors.accent.withOpacity(0.1),
          ),
          codeblockDecoration: BoxDecoration(
            color: const Color(0xFF0A0E27),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.3),
              width: 1,
            ),
          ),
          codeblockPadding: const EdgeInsets.all(16),
          // Blockquote
          blockquote: GoogleFonts.jetBrainsMono(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
          blockquoteDecoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.05),
            borderRadius: BorderRadius.circular(4),
            border: Border(
              left: BorderSide(
                color: AppColors.accent,
                width: 4,
              ),
            ),
          ),
          blockquotePadding: const EdgeInsets.all(12),
          // Horizontal rule
          horizontalRuleDecoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.accent.withOpacity(0.3),
                width: 2,
              ),
            ),
          ),
          // Strong (bold)
          strong: GoogleFonts.jetBrainsMono(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          // Emphasis (italic)
          em: GoogleFonts.jetBrainsMono(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
        onTapLink: (text, href, title) {
          if (href != null) {
            launchUrl(Uri.parse(href));
          }
        },
      ),
    );
  }

  IconData _getIconForFileType(FileType type) {
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
}
