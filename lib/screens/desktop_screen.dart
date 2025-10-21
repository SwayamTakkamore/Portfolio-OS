import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/ui_provider.dart';
import '../widgets/dock.dart';
import '../widgets/window_widget.dart';
import '../widgets/terminal_widget.dart';
import '../widgets/about_widget.dart';
import '../widgets/projects_widget.dart';
import '../widgets/resume_widget.dart';
import '../widgets/file_explorer_window.dart';
import '../constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({super.key});

  @override
  State<DesktopScreen> createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen>
    with SingleTickerProviderStateMixin {
  int _currentWallpaper = 0;
  final List<String> _wallpapers = [
    'assets/wallpapers/voidroot-1.jpg',
    'assets/wallpapers/voidroot-2.jpg',
  ];
  bool _isDockVisible = false;
  bool _isWallpaperLoaded = false;
  late AnimationController _dockAnimationController;
  late Animation<Offset> _dockSlideAnimation;

  @override
  void initState() {
    super.initState();
    _dockAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _dockSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Hidden below screen
      end: Offset.zero, // Visible
    ).animate(CurvedAnimation(
      parent: _dockAnimationController,
      curve: Curves.easeOut,
    ));

    // Precache all wallpapers
    _precacheWallpapers();
  }

  Future<void> _precacheWallpapers() async {
    for (String wallpaper in _wallpapers) {
      await precacheImage(AssetImage(wallpaper), context);
    }
    if (mounted) {
      setState(() {
        _isWallpaperLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _dockAnimationController.dispose();
    super.dispose();
  }

  void _showDock() {
    setState(() => _isDockVisible = true);
    _dockAnimationController.forward();
  }

  void _hideDock() {
    _dockAnimationController.reverse().then((_) {
      if (mounted) {
        setState(() => _isDockVisible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background (shows immediately)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A0E27),
                  const Color(0xFF1a1f3a),
                  const Color(0xFF2a1f3a),
                ],
              ),
            ),
          ),
          // Wallpaper image (fades in when loaded)
          if (_isWallpaperLoaded)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: _isWallpaperLoaded ? 1.0 : 0.0,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_wallpapers[_currentWallpaper]),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),
          // Loading indicator while wallpaper loads
          if (!_isWallpaperLoaded)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.accent,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading wallpaper...',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          // Top bar with blur
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context),
          ),
          // Desktop Icons (left side)
          Positioned(
            top: 60,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDesktopIcon(
                  icon: Icons.computer,
                  label: 'This PC',
                  onTap: () {
                    Provider.of<UIProvider>(context, listen: false)
                        .openWindow('file-explorer');
                  },
                ),
                const SizedBox(height: 16),
                _buildDesktopIcon(
                  icon: Icons.folder,
                  label: 'Documents',
                  onTap: () {
                    // Open documents folder
                  },
                ),
                const SizedBox(height: 16),
                _buildDesktopIcon(
                  icon: Icons.delete_outline,
                  label: 'Recycle Bin',
                  onTap: () {
                    // Open recycle bin
                  },
                ),
              ],
            ),
          ),
          // Windows
          Positioned.fill(
            top: 40,
            bottom: 0, // Changed from 100 to 0 since dock auto-hides
            child: Consumer<UIProvider>(
              builder: (context, uiProvider, _) {
                final windows = uiProvider.windows.values
                    .where((w) => w.isOpen && !w.isMinimized)
                    .toList()
                  ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

                return Stack(
                  children: [
                    for (var window in windows)
                      WindowWidget(
                        key: Key(window.id),
                        windowState: window,
                        child: _getWindowContent(window.id),
                      ),
                  ],
                );
              },
            ),
          ),
          // Dock hover trigger area (larger for better UX)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 10, // Larger area at bottom to trigger dock
            child: MouseRegion(
              onEnter: (_) => _showDock(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Auto-hide Dock
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: !_isDockVisible, // Make dock click-through when hidden
              child: MouseRegion(
                onEnter: (_) => _showDock(),
                onExit: (_) => _hideDock(),
                child: SlideTransition(
                  position: _dockSlideAnimation,
                  child: Dock(
                    onWallpaperChange: () {
                      setState(() {
                        _currentWallpaper =
                            (_currentWallpaper + 1) % _wallpapers.length;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateString = '${_getMonthName(now.month)} ${now.day}';

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.bgPanel.withOpacity(0.7),
            border: Border(
              bottom: BorderSide(
                color: AppColors.accent.withOpacity(0.3),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Activities button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // Could open activities overview
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withOpacity(0.3),
                          AppColors.accent2.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Activities',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // System tray with hover effects
              Row(
                children: [
                  _buildSystemIcon(Icons.wifi, 'Wi-Fi Connected'),
                  const SizedBox(width: 12),
                  _buildSystemIcon(Icons.volume_up, 'Volume'),
                  const SizedBox(width: 12),
                  _buildSystemIcon(Icons.battery_full, 'Battery Full'),
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.bgPrimary.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          timeString,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          dateString,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemIcon(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.bgPrimary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  Widget _buildDesktopIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 90,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.2),
                      AppColors.accent2.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.jetBrainsMono(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWindowContent(String id) {
    switch (id) {
      case 'terminal':
        return const TerminalWidget();
      case 'about':
        return const AboutWidget();
      case 'projects':
        return const ProjectsWidget();
      case 'resume':
        return const ResumeWidget();
      case 'file-explorer':
        return const FileExplorerWindow();
      default:
        return const Center(child: Text('Unknown window'));
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
