class WindowState {
  final String id;
  final String title;
  final String icon;
  final bool isOpen;
  final bool isMinimized;
  final bool isMaximized;
  final double x;
  final double y;
  final double width;
  final double height;
  final int zIndex;

  WindowState({
    required this.id,
    required this.title,
    required this.icon,
    this.isOpen = false,
    this.isMinimized = false,
    this.isMaximized = false,
    this.x = 100,
    this.y = 100,
    this.width = 800,
    this.height = 600,
    this.zIndex = 0,
  });

  WindowState copyWith({
    String? id,
    String? title,
    String? icon,
    bool? isOpen,
    bool? isMinimized,
    bool? isMaximized,
    double? x,
    double? y,
    double? width,
    double? height,
    int? zIndex,
  }) {
    return WindowState(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      isOpen: isOpen ?? this.isOpen,
      isMinimized: isMinimized ?? this.isMinimized,
      isMaximized: isMaximized ?? this.isMaximized,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      zIndex: zIndex ?? this.zIndex,
    );
  }
}
