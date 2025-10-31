import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:system_info2/system_info2.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../providers/ui_provider.dart';
import '../widgets/dock.dart';
import '../widgets/window_widget.dart';
import '../widgets/terminal_widget.dart';
import '../widgets/about_widget.dart';
import '../widgets/projects_widget.dart';
import '../widgets/resume_widget.dart';
import '../widgets/file_explorer_window.dart';
import '../widgets/documents_widget.dart';
import '../widgets/recycle_bin_widget.dart';
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

  // Real system state
  final Battery _battery = Battery();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Timer? _updateTimer;
  DateTime _currentTime = DateTime.now();

  // System info
  String _osName = 'Loading...';
  String _osVersion = 'Loading...';
  String _deviceModel = 'Loading...';
  int _totalMemoryMB = 0;
  int _freeMemoryMB = 0;
  int _cpuCores = 0;
  String _cpuArchitecture = 'Unknown';

  double _volume = 70.0;
  int _batteryLevel = 0;
  bool _isCharging = false;
  bool _isWifiConnected = false;
  String _wifiNetwork = 'Checking...';
  List<ConnectivityResult> _connectivityResult = [];

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

    // Initialize real system data
    _initSystemData();

    // Update time every second
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  Future<void> _initSystemData() async {
    // Get device and system info
    try {
      if (kIsWeb) {
        // Web platform
        final webInfo = await _deviceInfo.webBrowserInfo;
        _osName = webInfo.browserName.name;
        _osVersion = webInfo.appVersion ?? 'Unknown';
        _deviceModel = '${webInfo.platform ?? 'Web'} Browser';
        _cpuCores = 4; // Placeholder for web
        _totalMemoryMB = 8192; // Placeholder
        _cpuArchitecture = webInfo.platform ?? 'Web';
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        _osName = 'Windows';
        _osVersion = windowsInfo.displayVersion;
        _deviceModel = windowsInfo.computerName;

        // Get system info using system_info2
        _cpuCores = SysInfo.cores.length;
        _totalMemoryMB =
            (SysInfo.getTotalPhysicalMemory() / (1024 * 1024)).round();
        _freeMemoryMB =
            (SysInfo.getFreePhysicalMemory() / (1024 * 1024)).round();
        _cpuArchitecture = SysInfo.kernelArchitecture.name;
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        _osName = linuxInfo.name;
        _osVersion = linuxInfo.versionId ?? linuxInfo.version ?? 'Unknown';
        _deviceModel = linuxInfo.prettyName;

        _cpuCores = SysInfo.cores.length;
        _totalMemoryMB =
            (SysInfo.getTotalPhysicalMemory() / (1024 * 1024)).round();
        _freeMemoryMB =
            (SysInfo.getFreePhysicalMemory() / (1024 * 1024)).round();
        _cpuArchitecture = SysInfo.kernelArchitecture.name;
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfo.macOsInfo;
        _osName = 'macOS';
        _osVersion = macInfo.osRelease;
        _deviceModel = macInfo.computerName;

        _cpuCores = SysInfo.cores.length;
        _totalMemoryMB =
            (SysInfo.getTotalPhysicalMemory() / (1024 * 1024)).round();
        _freeMemoryMB =
            (SysInfo.getFreePhysicalMemory() / (1024 * 1024)).round();
        _cpuArchitecture = SysInfo.kernelArchitecture.name;
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        _osName = 'Android';
        _osVersion = androidInfo.version.release;
        _deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
        _cpuCores = 8; // Placeholder
        _totalMemoryMB = 6144; // Placeholder
        _cpuArchitecture =
            androidInfo.supported64BitAbis.isNotEmpty ? 'ARM64' : 'ARM';
      }
    } catch (e) {
      // Fallback values
      _osName = 'VOIDROOT OS';
      _osVersion = '1.0.0';
      _deviceModel = 'Unknown Device';
      _cpuCores = 4;
      _totalMemoryMB = 8192;
      _cpuArchitecture = 'x64';
    }

    // Get battery info
    try {
      _batteryLevel = await _battery.batteryLevel;
      _isCharging = await _battery.batteryState == BatteryState.charging;

      // Listen to battery changes
      _battery.onBatteryStateChanged.listen((BatteryState state) {
        if (mounted) {
          setState(() {
            _isCharging = state == BatteryState.charging;
          });
        }
      });
    } catch (e) {
      // Battery API not available (web), use placeholder
      _batteryLevel = 85;
    }

    // Get network info
    try {
      _connectivityResult = await Connectivity().checkConnectivity();
      _isWifiConnected =
          _connectivityResult.contains(ConnectivityResult.wifi) ||
              _connectivityResult.contains(ConnectivityResult.ethernet);

      if (_isWifiConnected) {
        _wifiNetwork = _connectivityResult.contains(ConnectivityResult.wifi)
            ? 'VoidRoot_Network'
            : 'Ethernet';
      } else {
        _wifiNetwork = 'Disconnected';
      }

      // Listen to connectivity changes
      Connectivity()
          .onConnectivityChanged
          .listen((List<ConnectivityResult> result) {
        if (mounted) {
          setState(() {
            _connectivityResult = result;
            _isWifiConnected = result.contains(ConnectivityResult.wifi) ||
                result.contains(ConnectivityResult.ethernet);
            if (_isWifiConnected) {
              _wifiNetwork = result.contains(ConnectivityResult.wifi)
                  ? 'VoidRoot_Network'
                  : 'Ethernet';
            } else {
              _wifiNetwork = 'Disconnected';
            }
          });
        }
      });
    } catch (e) {
      // Network API not available, use placeholder
      _isWifiConnected = true;
      _wifiNetwork = 'VoidRoot_Network';
    }

    if (mounted) {
      setState(() {});
    }
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
    _updateTimer?.cancel();
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
                    Provider.of<UIProvider>(context, listen: false)
                        .openWindow('documents');
                  },
                ),
                const SizedBox(height: 16),
                _buildDesktopIcon(
                  icon: Icons.delete_outline,
                  label: 'Recycle Bin',
                  onTap: () {
                    Provider.of<UIProvider>(context, listen: false)
                        .openWindow('recycle-bin');
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
    // Use real-time state
    final timeString = DateFormat('HH:mm:ss').format(_currentTime);
    final dateString = DateFormat('EEE, MMM d').format(_currentTime);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.bgDark.withOpacity(0.95),
            border: Border(
              bottom: BorderSide(
                color: AppColors.kaliBlue.withOpacity(0.3),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.kaliBlue.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Kali Linux logo/Activities button
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    // Could open activities overview
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.kaliBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppColors.kaliBlue.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.terminal,
                          size: 14,
                          color: AppColors.kaliCyan,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'VOIDROOT',
                          style: GoogleFonts.jetBrainsMono(
                            color: AppColors.textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // System tray with real data
              Row(
                children: [
                  _buildSystemIcon(
                    _isWifiConnected ? Icons.wifi : Icons.wifi_off,
                    _isWifiConnected
                        ? 'Connected: $_wifiNetwork'
                        : 'Disconnected',
                    onTap: () => _showWifiDialog(context),
                  ),
                  const SizedBox(width: 10),
                  _buildSystemIcon(
                    _volume == 0
                        ? Icons.volume_off
                        : _volume < 50
                            ? Icons.volume_down
                            : Icons.volume_up,
                    'Volume: ${_volume.toInt()}%',
                    onTap: () => _showVolumeDialog(context),
                  ),
                  const SizedBox(width: 10),
                  _buildSystemIcon(
                    _isCharging
                        ? Icons.battery_charging_full
                        : _batteryLevel > 80
                            ? Icons.battery_full
                            : _batteryLevel > 50
                                ? Icons.battery_6_bar
                                : _batteryLevel > 30
                                    ? Icons.battery_4_bar
                                    : Icons.battery_2_bar,
                    'Battery: $_batteryLevel%${_isCharging ? " (Charging)" : ""}',
                    onTap: () => _showBatteryDialog(context),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _showCalendarDialog(context),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.kaliBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: AppColors.kaliBlue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: AppColors.kaliCyan,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              timeString,
                              style: GoogleFonts.jetBrainsMono(
                                color: AppColors.textPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              dateString,
                              style: GoogleFonts.jetBrainsMono(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildSystemIcon(IconData icon, String tooltip,
      {VoidCallback? onTap}) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.bgPrimary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: AppColors.textPrimary),
          ),
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
      case 'documents':
        return const DocumentsWidget();
      case 'recycle-bin':
        return const RecycleBinWidget();
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

  // System Tray Dialogs
  void _showWifiDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _SystemDialog(
        title: 'Wi-Fi',
        icon: Icons.wifi,
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(
                  'Wi-Fi',
                  style: GoogleFonts.jetBrainsMono(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                value: _isWifiConnected,
                activeColor: AppColors.accent,
                onChanged: (value) {
                  setState(() {
                    this.setState(() {
                      _isWifiConnected = value;
                    });
                  });
                },
              ),
              if (_isWifiConnected) ...[
                const Divider(color: AppColors.accent),
                ListTile(
                  leading: const Icon(Icons.wifi, color: AppColors.accent),
                  title: Text(
                    _wifiNetwork,
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Connected',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.accent,
                      fontSize: 11,
                    ),
                  ),
                  trailing:
                      const Icon(Icons.check_circle, color: AppColors.accent),
                ),
                ListTile(
                  leading: const Icon(Icons.signal_wifi_4_bar,
                      color: AppColors.textSecondary),
                  title: Text(
                    'Guest_Network',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    'Available',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.wifi_lock,
                      color: AppColors.textSecondary),
                  title: Text(
                    'Office_Secure',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  subtitle: Text(
                    'Secured',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  trailing: const Icon(Icons.lock,
                      size: 16, color: AppColors.textSecondary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showVolumeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _SystemDialog(
        title: 'Volume',
        icon: Icons.volume_up,
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    _volume == 0
                        ? Icons.volume_off
                        : _volume < 50
                            ? Icons.volume_down
                            : Icons.volume_up,
                    color: AppColors.accent,
                  ),
                  Expanded(
                    child: Slider(
                      value: _volume,
                      min: 0,
                      max: 100,
                      activeColor: AppColors.accent,
                      inactiveColor: AppColors.accent.withOpacity(0.3),
                      onChanged: (value) {
                        setState(() {
                          this.setState(() {
                            _volume = value;
                          });
                        });
                      },
                    ),
                  ),
                  Text(
                    '${_volume.toInt()}%',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildVolumePreset('Mute', 0, setState),
                  _buildVolumePreset('Low', 30, setState),
                  _buildVolumePreset('Medium', 60, setState),
                  _buildVolumePreset('High', 100, setState),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolumePreset(String label, double value, StateSetter setState) {
    return InkWell(
      onTap: () {
        setState(() {
          this.setState(() {
            _volume = value;
          });
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _volume == value
              ? AppColors.accent.withOpacity(0.3)
              : AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _volume == value
                ? AppColors.accent
                : AppColors.accent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.jetBrainsMono(
            color: _volume == value ? AppColors.accent : AppColors.textPrimary,
            fontSize: 12,
            fontWeight: _volume == value ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  void _showBatteryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _SystemDialog(
        title: 'System Info',
        icon: Icons.info_outline,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Battery Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _batteryLevel > 80
                            ? Icons.battery_full
                            : _batteryLevel > 50
                                ? Icons.battery_6_bar
                                : _batteryLevel > 30
                                    ? Icons.battery_4_bar
                                    : _batteryLevel > 15
                                        ? Icons.battery_2_bar
                                        : Icons.battery_alert,
                        size: 48,
                        color: _batteryLevel < 20
                            ? AppColors.error
                            : AppColors.accent,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_batteryLevel%',
                            style: GoogleFonts.jetBrainsMono(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _isCharging ? 'Charging' : 'On Battery',
                            style: GoogleFonts.jetBrainsMono(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.accent, height: 1),

            // System Specifications
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Specifications',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSystemInfoRow(Icons.computer, 'Device', _deviceModel),
                  _buildSystemInfoRow(
                      Icons.desktop_windows, 'OS', '$_osName $_osVersion'),
                  _buildSystemInfoRow(Icons.memory, 'RAM',
                      '${(_totalMemoryMB / 1024).toStringAsFixed(1)} GB'),
                  _buildSystemInfoRow(Icons.storage, 'Free RAM',
                      '${(_freeMemoryMB / 1024).toStringAsFixed(1)} GB'),
                  _buildSystemInfoRow(Icons.settings_input_component,
                      'CPU Cores', '$_cpuCores cores'),
                  _buildSystemInfoRow(
                      Icons.architecture, 'Architecture', _cpuArchitecture),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.accent.withOpacity(0.7)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showCalendarDialog(BuildContext context) {
    final now = DateTime.now();
    showDialog(
      context: context,
      builder: (context) => _SystemDialog(
        title: 'Calendar',
        icon: Icons.calendar_today,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Current date display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.3),
                    AppColors.accent2.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    _getMonthName(now.month),
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.accent2,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${now.day}',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textPrimary,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${now.year}',
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Time
            Text(
              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
              style: GoogleFonts.jetBrainsMono(
                color: AppColors.accent,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.accent),
            // Quick info
            ListTile(
              leading: const Icon(Icons.wb_sunny, color: AppColors.accent2),
              title: Text(
                'Day ${now.difference(DateTime(now.year, 1, 1)).inDays + 1} of ${now.year}',
                style: GoogleFonts.jetBrainsMono(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.event, color: AppColors.accent),
              title: Text(
                'Week ${((now.difference(DateTime(now.year, 1, 1)).inDays) / 7).ceil()}',
                style: GoogleFonts.jetBrainsMono(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// System Dialog Widget
class _SystemDialog extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SystemDialog({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          color: AppColors.bgPanel.withOpacity(0.98),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title bar
            Container(
              height: 45,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.3),
                    AppColors.accent2.withOpacity(0.3),
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.accent2, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: GoogleFonts.jetBrainsMono(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    color: AppColors.textSecondary,
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
