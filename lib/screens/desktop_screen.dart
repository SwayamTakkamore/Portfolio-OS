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
import '../constants/app_colors.dart';

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
      body: Container(
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
        child: Stack(
          children: [
            // Top bar with blur
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopBar(context),
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
                ignoring:
                    !_isDockVisible, // Make dock click-through when hidden
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
