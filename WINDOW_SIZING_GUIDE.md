# 📐 Window Sizing Guide

Complete guide to adjusting window dimensions in your portfolio!

---

## 🎯 Where to Change Window Sizes

All window dimensions are defined in:
```
lib/providers/ui_provider.dart
```

---

## 📏 Terminal Window Dimensions

### **Current Settings (Updated)**
```dart
'terminal': WindowState(
  id: 'terminal',
  title: 'Terminal',
  icon: '⌘',
  x: 100,        // Starting X position
  y: 100,        // Starting Y position
  width: 900,    // ✨ Width in pixels (INCREASED from 700)
  height: 500,   // Height in pixels
),
```

### **Common Width Options**
```dart
width: 700,   // Compact (original)
width: 800,   // Medium
width: 900,   // Wide (current) ✅
width: 1000,  // Extra wide
width: 1200,  // Very wide
```

### **Common Height Options**
```dart
height: 400,  // Short
height: 500,  // Medium (current) ✅
height: 600,  // Tall
height: 700,  // Extra tall
height: 800,  // Very tall
```

---

## 🪟 All Window Sizes

### **Terminal** ⌘
```dart
width: 900,   // Wide for long commands
height: 500,  // Enough for command history
```

### **About Me** 👤
```dart
width: 600,   // Standard width
height: 500,  // Standard height
```

### **Projects** 💼
```dart
width: 800,   // Wide for project cards
height: 600,  // Tall for scrolling
```

### **Resume** 📄
```dart
width: 700,   // Document-like width
height: 600,  // Tall for resume content
```

---

## 🎨 Customization Examples

### **Make Terminal Full Width**
```dart
'terminal': WindowState(
  // ...
  width: 1200,   // Very wide
  height: 600,   // Taller too
),
```

### **Make All Windows Uniform**
```dart
// Same size for all windows
width: 800,
height: 600,
```

### **Make Terminal Vertical**
```dart
'terminal': WindowState(
  // ...
  width: 600,    // Narrower
  height: 800,   // Taller (portrait-like)
),
```

### **Ultra-Wide Terminal**
```dart
'terminal': WindowState(
  // ...
  width: 1400,   // Nearly full screen
  height: 700,   // Taller
),
```

---

## 📍 Position Properties

### **X Position** (Left/Right)
```dart
x: 50,    // Near left edge
x: 100,   // Default spacing
x: 200,   // More to the right
x: 300,   // Even further right
```

### **Y Position** (Top/Bottom)
```dart
y: 50,    // Near top
y: 100,   // Default spacing
y: 200,   // Lower
y: 300,   // Even lower
```

---

## 💡 Positioning Tips

### **Cascade Effect** (Professional Look)
```dart
'terminal': WindowState(
  x: 100, y: 100,  // First window
),
'about': WindowState(
  x: 150, y: 150,  // Offset by 50px
),
'projects': WindowState(
  x: 200, y: 200,  // Offset by another 50px
),
```

### **Grid Layout** (Organized)
```dart
'terminal': WindowState(
  x: 100, y: 100,  // Top-left quadrant
),
'about': WindowState(
  x: 600, y: 100,  // Top-right quadrant
),
'projects': WindowState(
  x: 100, y: 400,  // Bottom-left quadrant
),
```

### **Center Multiple Windows**
```dart
// Calculate: (screen_width - window_width) / 2
'terminal': WindowState(
  x: 260,  // Centered for 900px width on 1920px screen
  y: 150,
  width: 900,
),
```

---

## 🔧 Advanced Customization

### **Responsive Sizing**
If you want windows to be responsive to screen size, you'd need to calculate in the widget:

```dart
// In window_widget.dart (advanced)
final screenSize = MediaQuery.of(context).size;
final responsiveWidth = screenSize.width * 0.6;  // 60% of screen
```

### **Maximum Sizes**
When maximized, windows automatically use:
```dart
// In window_widget.dart
width: screenSize.width - 0,    // Full width
height: screenSize.height - 40,  // Full height minus top bar
```

---

## 📊 Screen Size Reference

### **Common Screen Widths**
- **1366x768**: Small laptop
- **1920x1080**: Standard desktop (Full HD)
- **2560x1440**: 2K monitor
- **3840x2160**: 4K monitor

### **Safe Window Sizes**
For windows to fit on most screens:
```dart
width: 800,   // Fits 1366px screens
height: 600,  // Fits 768px screens
```

### **Wide Screen Optimized**
For 1920px+ screens:
```dart
width: 1200,  // Takes advantage of width
height: 800,  // Tall
```

---

## 🎯 Quick Recipes

### **1. Make Terminal Wider for Long Commands**
```dart
'terminal': WindowState(
  width: 1000,  // +300px wider
  height: 500,
),
```

### **2. Make Terminal Taller for More History**
```dart
'terminal': WindowState(
  width: 900,
  height: 700,  // +200px taller
),
```

### **3. Make Terminal Square**
```dart
'terminal': WindowState(
  width: 800,
  height: 800,  // Same width and height
),
```

### **4. Make All Windows Large**
```dart
'terminal': WindowState(
  width: 1000, height: 700,
),
'about': WindowState(
  width: 900, height: 700,
),
'projects': WindowState(
  width: 1000, height: 800,
),
'resume': WindowState(
  width: 900, height: 800,
),
```

---

## 🎨 Professional Window Layouts

### **Layout 1: Developer Focus** (Big Terminal)
```dart
'terminal': WindowState(
  x: 100, y: 100,
  width: 1200,  // Very wide terminal
  height: 700,  // Tall terminal
),
```

### **Layout 2: Balanced**
```dart
'terminal': WindowState(
  width: 900,   // Wide enough
  height: 600,  // Medium height
),
'projects': WindowState(
  width: 900,   // Same width
  height: 650,  // Slightly taller
),
```

### **Layout 3: Compact**
```dart
// All windows smaller for busy screen
'terminal': WindowState(
  width: 700, height: 500,
),
'about': WindowState(
  width: 600, height: 450,
),
```

---

## 🔄 How Changes Apply

### **Hot Reload** ⚡
After changing values in `ui_provider.dart`:
1. Save the file
2. Press `r` in terminal (hot reload)
3. Close and reopen the terminal window to see new size

### **Full Restart** 🔄
If hot reload doesn't work:
1. Press `R` in terminal (hot restart)
2. Or stop and restart `flutter run`

---

## 📝 Testing Different Sizes

### **Quick Test Method**
Try these sizes to find your preference:

```dart
// Test 1: Original
width: 700, height: 500

// Test 2: Slightly wider
width: 800, height: 500

// Test 3: Wide (current)
width: 900, height: 500  ✅

// Test 4: Extra wide
width: 1000, height: 500

// Test 5: Ultra wide
width: 1200, height: 600
```

---

## 🎯 Recommendation

### **For Terminal**
```dart
width: 900,   // Wide enough for long commands ✅ (CURRENT)
height: 600,  // Enough vertical space for history
```

### **Reasoning:**
- ✅ Fits most screens (1366px+)
- ✅ Shows long commands without wrapping
- ✅ Enough space for neofetch ASCII art
- ✅ Professional look
- ✅ Not overwhelming

---

## 🐛 Troubleshooting

### **Window Too Wide for Screen?**
Reduce width:
```dart
width: 800,  // Or smaller
```

### **Window Extends Off Screen?**
Adjust starting position:
```dart
x: 50,   // Start closer to edge
y: 50,
```

### **Text Looks Cramped?**
Increase padding in terminal_widget.dart:
```dart
padding: const EdgeInsets.all(24),  // More space
```

### **Can't See Full Commands?**
Increase width:
```dart
width: 1000,  // Or larger
```

---

## 📚 Related Files

- **Window Dimensions**: `lib/providers/ui_provider.dart` ← You are here
- **Window Behavior**: `lib/widgets/window_widget.dart`
- **Terminal Content**: `lib/widgets/terminal_widget.dart`
- **Desktop Layout**: `lib/screens/desktop_screen.dart`

---

## ✨ Current Setup

✅ **Terminal window width increased to 900px** (from 700px)
- Better for long commands
- More professional appearance
- Fits neofetch output perfectly
- Still works on smaller screens

---

*Adjust these values to match your design preferences!* 🎨
