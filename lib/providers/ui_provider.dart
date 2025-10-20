import 'package:flutter/material.dart';
import '../models/window_state.dart';

class UIProvider extends ChangeNotifier {
  int _maxZIndex = 0;

  final Map<String, WindowState> _windows = {
    'terminal': WindowState(
      id: 'terminal',
      title: 'Terminal',
      icon: '⌘',
      x: 100,
      y: 100,
      width: 950, // Increased from 700 to 900 (wider terminal)
      height: 700,
    ),
    'about': WindowState(
      id: 'about',
      title: 'About Me',
      icon: '👤',
      x: 150,
      y: 150,
      width: 900,
      height: 700,
    ),
    'projects': WindowState(
      id: 'projects',
      title: 'Projects',
      icon: '💼',
      x: 200,
      y: 200,
      width: 800,
      height: 600,
    ),
    'resume': WindowState(
      id: 'resume',
      title: 'Resume',
      icon: '📄',
      x: 250,
      y: 150,
      width: 700,
      height: 600,
    ),
  };

  Map<String, WindowState> get windows => _windows;

  void openWindow(String id) {
    if (_windows.containsKey(id)) {
      _maxZIndex++;
      _windows[id] = _windows[id]!.copyWith(
        isOpen: true,
        isMinimized: false,
        zIndex: _maxZIndex,
      );
      notifyListeners();
    }
  }

  void closeWindow(String id) {
    if (_windows.containsKey(id)) {
      _windows[id] = _windows[id]!.copyWith(isOpen: false);
      notifyListeners();
    }
  }

  void minimizeWindow(String id) {
    if (_windows.containsKey(id)) {
      _windows[id] = _windows[id]!.copyWith(isMinimized: true);
      notifyListeners();
    }
  }

  void maximizeWindow(String id) {
    if (_windows.containsKey(id)) {
      final window = _windows[id]!;
      _windows[id] = window.copyWith(
        isMaximized: !window.isMaximized,
      );
      notifyListeners();
    }
  }

  void focusWindow(String id) {
    if (_windows.containsKey(id)) {
      _maxZIndex++;
      _windows[id] = _windows[id]!.copyWith(zIndex: _maxZIndex);
      notifyListeners();
    }
  }

  void updateWindowPosition(String id, double x, double y) {
    if (_windows.containsKey(id)) {
      _windows[id] = _windows[id]!.copyWith(x: x, y: y);
      notifyListeners();
    }
  }

  void updateWindowSize(String id, double width, double height) {
    if (_windows.containsKey(id)) {
      _windows[id] = _windows[id]!.copyWith(width: width, height: height);
      notifyListeners();
    }
  }
}
