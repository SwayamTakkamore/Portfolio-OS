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

  // Resizing state
  bool _isResizing = false;
  String _resizeDirection = '';
  late double _currentWidth;
  late double _currentHeight;

  @override
  void initState() {
    super.initState();
    _position = Offset(widget.windowState.x, widget.windowState.y);
    _currentWidth = widget.windowState.width;
    _currentHeight = widget.windowState.height;
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
        final effectiveY = isMaximized ? 0.0 : _position.dy;
        final effectiveWidth = isMaximized ? screenSize.width : _currentWidth;
        final effectiveHeight =
            isMaximized ? screenSize.height - 40.0 : _currentHeight;

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
              child: Stack(
                children: [
                  // Main window content
                  Container(
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
                                      () => uiProvider.minimizeWindow(
                                          widget.windowState.id),
                                    ),
                                    const SizedBox(width: 10),
                                    _buildTrafficLight(
                                      AppColors.maximizeGreen,
                                      Icons.crop_square,
                                      _isHoveringMaximize,
                                      (hovering) => setState(
                                          () => _isHoveringMaximize = hovering),
                                      () => uiProvider.maximizeWindow(
                                          widget.windowState.id),
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
                                        width:
                                            100), // Balance for traffic lights
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

                  // Resize handles (only show when not maximized)
                  if (!isMaximized) ...[
                    // Bottom-right corner
                    _buildResizeHandle(
                      alignment: Alignment.bottomRight,
                      cursor: SystemMouseCursors.resizeDownRight,
                      direction: 'br',
                      uiProvider: uiProvider,
                      currentWindow: currentWindow,
                    ),
                    // Bottom edge
                    _buildResizeHandle(
                      alignment: Alignment.bottomCenter,
                      cursor: SystemMouseCursors.resizeDown,
                      direction: 'b',
                      uiProvider: uiProvider,
                      currentWindow: currentWindow,
                    ),
                    // Right edge
                    _buildResizeHandle(
                      alignment: Alignment.centerRight,
                      cursor: SystemMouseCursors.resizeRight,
                      direction: 'r',
                      uiProvider: uiProvider,
                      currentWindow: currentWindow,
                    ),
                    // Bottom-left corner
                    _buildResizeHandle(
                      alignment: Alignment.bottomLeft,
                      cursor: SystemMouseCursors.resizeDownLeft,
                      direction: 'bl',
                      uiProvider: uiProvider,
                      currentWindow: currentWindow,
                    ),
                    // Left edge
                    _buildResizeHandle(
                      alignment: Alignment.centerLeft,
                      cursor: SystemMouseCursors.resizeLeft,
                      direction: 'l',
                      uiProvider: uiProvider,
                      currentWindow: currentWindow,
                    ),
                    // Top-right corner
                    _buildResizeHandle(
                      alignment: Alignment.topRight,
                      cursor: SystemMouseCursors.resizeUpRight,
                      direction: 'tr',
                      uiProvider: uiProvider,
                      currentWindow: currentWindow,
                    ),
                    // Top-left corner
                    _buildResizeHandle(
                      alignment: Alignment.topLeft,
                      cursor: SystemMouseCursors.resizeUpLeft,
                      direction: 'tl',
                      uiProvider: uiProvider,
                      currentWindow: currentWindow,
                    ),
                    // Top edge
                    _buildResizeHandle(
                      alignment: Alignment.topCenter,
                      cursor: SystemMouseCursors.resizeUp,
                      direction: 't',
                      uiProvider: uiProvider,
                      currentWindow: currentWindow,
                    ),
                  ],
                ],
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
      case 'file-explorer':
        return Icons.folder_open;
      case 'documents':
        return Icons.description;
      case 'recycle-bin':
        return Icons.delete_outline;
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

  Widget _buildResizeHandle({
    required Alignment alignment,
    required MouseCursor cursor,
    required String direction,
    required UIProvider uiProvider,
    required currentWindow,
  }) {
    const handleSize = 16.0;
    bool isEdge = direction.length == 1;

    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: MouseRegion(
          cursor: cursor,
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                _isResizing = true;
                _resizeDirection = direction;
              });
            },
            onPanUpdate: (details) {
              if (!_isResizing) return;

              setState(() {
                // Handle width changes
                if (direction.contains('r')) {
                  _currentWidth =
                      (_currentWidth + details.delta.dx).clamp(400.0, 1400.0);
                } else if (direction.contains('l')) {
                  double newWidth =
                      (_currentWidth - details.delta.dx).clamp(400.0, 1400.0);
                  if (newWidth >= 400.0) {
                    _position =
                        Offset(_position.dx + details.delta.dx, _position.dy);
                    _currentWidth = newWidth;
                  }
                }

                // Handle height changes
                if (direction.contains('b')) {
                  _currentHeight =
                      (_currentHeight + details.delta.dy).clamp(300.0, 900.0);
                } else if (direction.contains('t')) {
                  double newHeight =
                      (_currentHeight - details.delta.dy).clamp(300.0, 900.0);
                  if (newHeight >= 300.0) {
                    _position =
                        Offset(_position.dx, _position.dy + details.delta.dy);
                    _currentHeight = newHeight;
                  }
                }
              });

              // Update window size in provider
              uiProvider.updateWindowSize(
                currentWindow.id,
                _currentWidth,
                _currentHeight,
              );
            },
            onPanEnd: (details) {
              setState(() {
                _isResizing = false;
                _resizeDirection = '';
              });
            },
            child: Container(
              width: isEdge
                  ? (direction == 'l' || direction == 'r'
                      ? handleSize
                      : double.infinity)
                  : handleSize,
              height: isEdge
                  ? (direction == 't' || direction == 'b'
                      ? handleSize
                      : double.infinity)
                  : handleSize,
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
