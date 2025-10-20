import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/ui_provider.dart';
import '../constants/app_colors.dart';

class DockItem {
  final String id;
  final String icon;
  final String label;

  DockItem({required this.id, required this.icon, required this.label});
}

class Dock extends StatefulWidget {
  final VoidCallback? onWallpaperChange;

  const Dock({super.key, this.onWallpaperChange});

  @override
  State<Dock> createState() => _DockState();
}

class _DockState extends State<Dock> {
  final List<DockItem> _dockItems = [
    DockItem(id: 'terminal', icon: '⌘', label: 'Terminal'),
    DockItem(id: 'about', icon: '👤', label: 'About'),
    DockItem(id: 'projects', icon: '💼', label: 'Projects'),
    DockItem(id: 'resume', icon: '📄', label: 'Resume'),
  ];

  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            height: 90,
            margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.bgPanel.withOpacity(0.85),
                  AppColors.bgPanel.withOpacity(0.75),
                  AppColors.bgPanel.withOpacity(0.65),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.4),
                width: 1.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 40,
                  spreadRadius: 8,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: AppColors.accent2.withOpacity(0.1),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Consumer<UIProvider>(
              builder: (context, uiProvider, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < _dockItems.length; i++)
                      _buildDockItem(
                        context,
                        _dockItems[i],
                        i,
                        uiProvider,
                      ),
                    // Wallpaper changer button
                    const SizedBox(width: 8),
                    _buildWallpaperButton(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWallpaperButton() {
    final isHovered = _hoveredIndex == -1;
    final scale = isHovered ? 1.35 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = -1),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: widget.onWallpaperChange,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticOut,
          child: Container(
            width: 56,
            height: 56,
            margin: const EdgeInsets.only(left: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isHovered
                    ? [
                        AppColors.accent,
                        AppColors.accent2,
                      ]
                    : [
                        AppColors.accent.withOpacity(0.7),
                        AppColors.accent2.withOpacity(0.7),
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isHovered
                    ? AppColors.accent.withOpacity(0.9)
                    : AppColors.accent.withOpacity(0.5),
                width: 2.5,
              ),
              boxShadow: [
                if (isHovered)
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.wallpaper_rounded,
              color: Colors.white,
              size: isHovered ? 28 : 26,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDockItem(
    BuildContext context,
    DockItem item,
    int index,
    UIProvider uiProvider,
  ) {
    final window = uiProvider.windows[item.id];
    final isActive = window?.isOpen == true && window?.isMinimized == false;
    final isHovered = _hoveredIndex == index;
    final scale = isHovered ? 1.5 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: () {
          if (isActive) {
            uiProvider.minimizeWindow(item.id);
          } else {
            uiProvider.openWindow(item.id);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Icon
              AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isActive
                          ? [
                              AppColors.accent.withOpacity(0.4),
                              AppColors.accent2.withOpacity(0.4),
                              AppColors.accent.withOpacity(0.3),
                            ]
                          : isHovered
                              ? [
                                  AppColors.bgPanel.withOpacity(0.95),
                                  AppColors.bgPanel.withOpacity(0.85),
                                  AppColors.bgPanel.withOpacity(0.75),
                                ]
                              : [
                                  AppColors.bgPanel.withOpacity(0.85),
                                  AppColors.bgPanel.withOpacity(0.75),
                                  AppColors.bgPanel.withOpacity(0.65),
                                ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive
                          ? AppColors.accent.withOpacity(0.9)
                          : isHovered
                              ? AppColors.accent.withOpacity(0.5)
                              : AppColors.accent.withOpacity(0.25),
                      width: isActive
                          ? 2.8
                          : isHovered
                              ? 2.0
                              : 1.6,
                    ),
                    boxShadow: [
                      if (isActive || isHovered)
                        BoxShadow(
                          color: isActive
                              ? AppColors.accent.withOpacity(0.5)
                              : AppColors.accent.withOpacity(0.3),
                          blurRadius: isActive ? 20 : 15,
                          spreadRadius: isActive ? 4 : 2,
                        ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                      if (isActive)
                        BoxShadow(
                          color: AppColors.accent2.withOpacity(0.3),
                          blurRadius: 18,
                          spreadRadius: 3,
                        ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: isHovered ? 30 : 28,
                        height: 1.0,
                      ),
                      child: Text(item.icon),
                    ),
                  ),
                ),
              ),
              // macOS-style active indicator (bottom dot)
              if (isActive)
                Positioned(
                  bottom: -10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isHovered ? 10 : 7,
                      height: isHovered ? 10 : 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.accent,
                            AppColors.accent2,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.8),
                            blurRadius: 12,
                            spreadRadius: 3,
                          ),
                          BoxShadow(
                            color: AppColors.accent2.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              // Tooltip with enhanced blur and glow
              if (isHovered)
                Positioned(
                  bottom: 75,
                  left: -35,
                  right: -35,
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.bgPanel.withOpacity(0.95),
                                  AppColors.bgPanel.withOpacity(0.85),
                                  AppColors.bgPanel.withOpacity(0.75),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.accent.withOpacity(0.5),
                                width: 1.8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                                BoxShadow(
                                  color: AppColors.accent.withOpacity(0.2),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              item.label,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
