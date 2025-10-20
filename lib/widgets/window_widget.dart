import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/ui_provider.dart';
import '../models/window_state.dart';
import '../constants/app_colors.dart';

class WindowWidget extends StatefulWidget {
  final WindowState windowState;
  final Widget child;

  const WindowWidget({
    super.key,
    required this.windowState,
    required this.child,
  });

  @override
  State<WindowWidget> createState() => _WindowWidgetState();
}

class _WindowWidgetState extends State<WindowWidget>
    with SingleTickerProviderStateMixin {
  late Offset _position;
  bool _isHoveringClose = false;
  bool _isHoveringMinimize = false;
  bool _isHoveringMaximize = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _position = Offset(widget.windowState.x, widget.windowState.y);
    _animController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Consumer<UIProvider>(
      builder: (context, uiProvider, _) {
        // Get fresh window state
        final currentWindow = uiProvider.windows[widget.windowState.id];
        if (currentWindow == null) return const SizedBox();

        // Calculate position and size based on maximize state
        final isMaximized = currentWindow.isMaximized;
        final effectiveX = isMaximized ? 0.0 : _position.dx;
        final effectiveY = isMaximized ? 0.0 : _position.dy; // 40 for top bar
        final effectiveWidth =
            isMaximized ? screenSize.width : currentWindow.width;
        final effectiveHeight = isMaximized
            ? screenSize.height - 40.0
            : currentWindow
                .height; // subtract only top bar (40) since dock auto-hides

        return Positioned(
          left: effectiveX,
          top: effectiveY,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onPanUpdate: isMaximized
                  ? null
                  : (details) {
                      setState(() {
                        _position += details.delta;
                      });
                      uiProvider.updateWindowPosition(
                        currentWindow.id,
                        _position.dx,
                        _position.dy,
                      );
                    },
              onTap: () => uiProvider.focusWindow(currentWindow.id),
              child: Container(
                width: effectiveWidth,
                height: effectiveHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgPanel.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Title bar with glassmorphism
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColors.bgPanel.withOpacity(0.9),
                                  AppColors.bgPanel.withOpacity(0.6),
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.accent.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                // Traffic lights (Ubuntu style with hover effects)
                                _buildTrafficLight(
                                  AppColors.closeRed,
                                  Icons.close,
                                  _isHoveringClose,
                                  (hovering) => setState(
                                      () => _isHoveringClose = hovering),
                                  () => uiProvider
                                      .closeWindow(widget.windowState.id),
                                ),
                                const SizedBox(width: 10),
                                _buildTrafficLight(
                                  AppColors.minimizeYellow,
                                  Icons.remove,
                                  _isHoveringMinimize,
                                  (hovering) => setState(
                                      () => _isHoveringMinimize = hovering),
                                  () => uiProvider
                                      .minimizeWindow(widget.windowState.id),
                                ),
                                const SizedBox(width: 10),
                                _buildTrafficLight(
                                  AppColors.maximizeGreen,
                                  Icons.crop_square,
                                  _isHoveringMaximize,
                                  (hovering) => setState(
                                      () => _isHoveringMaximize = hovering),
                                  () => uiProvider
                                      .maximizeWindow(widget.windowState.id),
                                ),
                                // Title (centered with icon)
                                Expanded(
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getIconForWindow(
                                              widget.windowState.id),
                                          color: AppColors.accent,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          widget.windowState.title,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width: 100), // Balance for traffic lights
                              ],
                            ),
                          ),
                          // Content
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppColors.bgPrimary,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                child: widget.child,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ); // Close Consumer builder
      },
    ); // Close Consumer
  }

  IconData _getIconForWindow(String id) {
    switch (id) {
      case 'terminal':
        return Icons.terminal;
      case 'about':
        return Icons.person;
      case 'projects':
        return Icons.folder;
      case 'resume':
        return Icons.description;
      default:
        return Icons.window;
    }
  }

  Widget _buildTrafficLight(
    Color color,
    IconData icon,
    bool isHovering,
    Function(bool) onHover,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: isHovering
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: isHovering
              ? Icon(
                  icon,
                  size: 8,
                  color: Colors.black.withOpacity(0.7),
                )
              : null,
        ),
      ),
    );
  }
}
