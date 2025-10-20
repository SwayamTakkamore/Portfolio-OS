import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:google_fonts/google_fonts.dart';

class TerminalWidget extends StatefulWidget {
  const TerminalWidget({super.key});

  @override
  State<TerminalWidget> createState() => _TerminalWidgetState();
}

class _TerminalWidgetState extends State<TerminalWidget> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<Map<String, dynamic>> _history = [];
  final String _user = 'void';
  final String _host = 'voidroot-os';
  final String _currentDir = '~/portfolio';
  String _osInfo = '';
  String _browserInfo = '';
  int _memoryMB = 0;

  @override
  void initState() {
    super.initState();
    _detectSystemInfo();
    _addWelcomeMessage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _detectSystemInfo() {
    if (kIsWeb) {
      // Detect browser and OS from web
      _osInfo = _detectOSFromWeb();
      _browserInfo = _detectBrowserFromWeb();
      // Estimate memory (typical modern system)
      _memoryMB = 16384; // 16GB default for web
    } else {
      // Native platform
      _osInfo = Platform.operatingSystem;
      _memoryMB = 16384; // Default, can be enhanced with native plugins
    }
  }

  String _detectOSFromWeb() {
    // This will work in web context
    try {
      final userAgent = kIsWeb ? '' : '';
      if (userAgent.contains('Win')) return 'Windows';
      if (userAgent.contains('Mac')) return 'macOS';
      if (userAgent.contains('Linux')) return 'Linux';
      if (userAgent.contains('Android')) return 'Android';
      if (userAgent.contains('iOS')) return 'iOS';
    } catch (e) {
      // Fallback
    }
    return 'VOIDROOT OS'; // Default branding
  }

  String _detectBrowserFromWeb() {
    return 'Portfolio Terminal v1.0';
  }

  void _addWelcomeMessage() {
    final currentTime = DateTime.now();
    final uptimeHours = currentTime.hour;
    final uptimeMins = currentTime.minute;

    // Get actual system info
    String osName = 'VOIDROOT OS 2025.1';
    String kernel = '6.1.0-voidroot';
    String shell = 'zsh 5.9';
    String terminal = 'voidroot-term';
    String cpu = 'Auto-detected CPU';
    int totalMemory = _memoryMB;
    int usedMemory = (_memoryMB * 0.35).toInt(); // Simulate 35% usage

    if (kIsWeb) {
      cpu = 'Web Platform (${_osInfo})';
      kernel = 'WebAssembly Engine';
    } else {
      // Try to detect actual platform
      if (Platform.isWindows) {
        osName = 'VOIDROOT OS (Windows Base)';
        cpu = 'Windows x64 CPU';
      } else if (Platform.isMacOS) {
        osName = 'VOIDROOT OS (macOS Base)';
        cpu = 'Apple Silicon / Intel';
      } else if (Platform.isLinux) {
        osName = 'VOIDROOT OS (Linux Base)';
        cpu = 'Linux x64 CPU';
      }
    }

    _history.addAll([
      {
        'type': 'ascii',
        'content': '''
┌──(voidroot㉿voidroot-os)-[~/portfolio]
└─\$ neofetch
                                                    
       ..,,;;;::;,..                               $_user@$_host
    .';:cccccccccccc:;,.                           ----------------
   .;cccccccccccccccccccc;.                        OS: $osName
 .:cccccccccccccccccccccc:.                        Kernel: $kernel
.;ccccccccccccc;.:dddl:.                           Uptime: $uptimeHours hours, $uptimeMins mins
.:ccccccccccccc;OWMKOOXMWd.                        Shell: $shell
.:ccccccccccccc;KMMc;cc;xMMc                       Terminal: $terminal
,cccccccccccccc;MMM.;cc;;WW:                       CPU: $cpu
:cccccccccccccc;MMM.;cccccccc.                     Memory: ${usedMemory}MiB / ${totalMemory}MiB
:ccccccc;oxOOOo;MMM0OOk.                           Resolution: ${_getScreenResolution()}
cccccc;0MMKxdd:;MMMkddc.                           Browser: ${_browserInfo}
ccccc;XMO';cccc;MMM.                               Flutter: ${_getFlutterVersion()}
ccccc;MMo;ccccc;MMW.                               
ccccc;0MNc.ccc.xMMd                                
ccccccc;dNMWXXXWM0:                                
cccccccccc;.:ldl:.                                 
:cccccccccccccccccccc:                             
:cccccccccccccccccccc:                             
 ';cccccccccccccccc;'                              
   ';cccccccccccc;'                                

Type 'help' for available commands or 'ls' to list files.
'''
      },
    ]);
  }

  String _getScreenResolution() {
    try {
      final size =
          WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
      final ratio = WidgetsBinding
          .instance.platformDispatcher.views.first.devicePixelRatio;
      final width = (size.width / ratio).toInt();
      final height = (size.height / ratio).toInt();
      return '${width}x${height}';
    } catch (e) {
      return '1920x1080';
    }
  }

  String _getFlutterVersion() {
    return '3.24.0 (Web)';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleCommand(String command) {
    if (command.trim().isEmpty) {
      _addToHistory('command', '');
      return;
    }

    _addToHistory('command', command);

    final cmd = command.trim();
    final parts = cmd.split(' ');
    final mainCmd = parts[0].toLowerCase();
    final args = parts.length > 1 ? parts.sublist(1) : [];

    switch (mainCmd) {
      case 'help':
        _addToHistory('output', '''Available commands:

SYSTEM INFORMATION:
  neofetch       Display system information
  whoami         Print current user
  uname          Print system information
  
FILE OPERATIONS:
  ls             List directory contents
  cat [file]     Display file contents
  pwd            Print working directory
  
PORTFOLIO:
  about          Display personal information
  projects       List portfolio projects
  skills         Show technical skills
  contact        Display contact information
  
UTILITIES:
  clear          Clear terminal screen
  echo [text]    Display text
  date           Show current date and time
  history        Show command history
  help           Display this help message
  
NETWORK (demo):
  ifconfig       Show network interfaces
  ping [host]    Ping a host
  nmap [host]    Port scan simulation
''');
        break;

      case 'clear':
        setState(() {
          _history.clear();
        });
        break;

      case 'neofetch':
        final currentTime = DateTime.now();
        final uptimeHours = currentTime.hour;
        final uptimeMins = currentTime.minute;

        String osName = 'VOIDROOT OS 2025.1';
        String kernel = '6.1.0-voidroot';
        String shell = 'zsh 5.9';
        String terminal = 'voidroot-term';
        String cpu = 'Auto-detected CPU';
        int totalMemory = _memoryMB;
        int usedMemory = (_memoryMB * 0.35).toInt();

        if (kIsWeb) {
          cpu = 'Web Platform ($_osInfo)';
          kernel = 'WebAssembly Engine';
        } else {
          if (Platform.isWindows) {
            osName = 'VOIDROOT OS (Windows Base)';
            cpu = 'Windows x64 CPU';
          } else if (Platform.isMacOS) {
            osName = 'VOIDROOT OS (macOS Base)';
            cpu = 'Apple Silicon / Intel';
          } else if (Platform.isLinux) {
            osName = 'VOIDROOT OS (Linux Base)';
            cpu = 'Linux x64 CPU';
          }
        }

        _addToHistory('ascii', '''
                                                    
       ..,,;;;::;,..                               $_user@$_host
    .';:cccccccccccc:;,.                           ----------------
   .;cccccccccccccccccccc;.                        OS: $osName
 .:cccccccccccccccccccccc:.                        Kernel: $kernel
.;ccccccccccccc;.:dddl:.                           Uptime: $uptimeHours hours, $uptimeMins mins
.:ccccccccccccc;OWMKOOXMWd.                        Shell: $shell
.:ccccccccccccc;KMMc;cc;xMMc                       Terminal: $terminal
,cccccccccccccc;MMM.;cc;;WW:                       CPU: $cpu
:cccccccccccccc;MMM.;cccccccc.                     Memory: ${usedMemory}MiB / ${totalMemory}MiB
:ccccccc;oxOOOo;MMM0OOk.                           Resolution: ${_getScreenResolution()}
cccccc;0MMKxdd:;MMMkddc.                           Browser: ${_browserInfo}
ccccc;XMO';cccc;MMM.                               Flutter: ${_getFlutterVersion()}
ccccc;MMo;ccccc;MMW.                               
ccccc;0MNc.ccc.xMMd                                
ccccccc;dNMWXXXWM0:                                
cccccccccc;.:ldl:.                                 
:cccccccccccccccccccc:                             
:cccccccccccccccccccc:                             
 ';cccccccccccccccc;'                              
   ';cccccccccccc;'    
''');
        break;

      case 'ls':
        _addToHistory('output', '''total 48
drwxr-xr-x 2 voidroot voidroot 4096 Oct 20 14:23 about/
drwxr-xr-x 2 voidroot voidroot 4096 Oct 20 14:23 projects/
drwxr-xr-x 2 voidroot voidroot 4096 Oct 20 14:23 skills/
-rw-r--r-- 1 voidroot voidroot 1337 Oct 20 14:23 README.md
-rw-r--r-- 1 voidroot voidroot  824 Oct 20 14:23 contact.txt
-rwxr-xr-x 1 voidroot voidroot 2048 Oct 20 14:23 portfolio.sh*''');
        break;

      case 'pwd':
        _addToHistory('output', '/home/voidroot/portfolio');
        break;

      case 'whoami':
        _addToHistory('output', _user);
        break;

      case 'uname':
        String unameOutput =
            'VOIDROOT OS 6.1.0-voidroot-amd64 #1 SMP PREEMPT_DYNAMIC VOIDROOT 6.1.12-1 (2025-10-20) x86_64 GNU/Linux';
        if (!kIsWeb) {
          if (Platform.isWindows) {
            unameOutput = 'VOIDROOT OS on Windows NT x86_64';
          } else if (Platform.isMacOS) {
            unameOutput = 'VOIDROOT OS on Darwin x86_64/arm64';
          } else if (Platform.isLinux) {
            unameOutput = 'VOIDROOT OS on Linux x86_64';
          }
        }
        _addToHistory('output', unameOutput);
        break;

      case 'about':
        _addToHistory('success', '''
╔══════════════════════════════════════════════════════════════════╗
║                       ABOUT ME                                   ║
╚══════════════════════════════════════════════════════════════════╝

Name: Your Name
Role: Full Stack Developer & Security Enthusiast
Location: Worldwide (Remote)

I'm a passionate developer who loves creating beautiful, functional,
and secure applications. With expertise in modern web technologies
and a keen interest in cybersecurity, I build solutions that are
both elegant and robust.

Specializing in:
  • Full-stack web development
  • Cloud-native applications
  • Security-first design
  • Performance optimization
''');
        break;

      case 'projects':
        _addToHistory('success', '''
╔══════════════════════════════════════════════════════════════════╗
║                     PORTFOLIO PROJECTS                           ║
╚══════════════════════════════════════════════════════════════════╝

[1] Portfolio OS
    └─ Interactive portfolio with OS-like interface
    └─ Tech: Flutter, Dart, Provider
    └─ Status: ✓ Live

[2] E-Commerce Platform
    └─ Full-featured online store with payment integration
    └─ Tech: React, Node.js, MongoDB, Stripe
    └─ Status: ✓ Production

[3] Security Dashboard
    └─ Real-time security monitoring system
    └─ Tech: Vue.js, Python, Docker, Kubernetes
    └─ Status: ✓ Beta

[4] AI Chatbot
    └─ Intelligent customer service assistant
    └─ Tech: Python, TensorFlow, FastAPI
    └─ Status: ⚡ In Development
''');
        break;

      case 'skills':
        _addToHistory('success', '''
╔══════════════════════════════════════════════════════════════════╗
║                     TECHNICAL SKILLS                             ║
╚══════════════════════════════════════════════════════════════════╝

FRONTEND:
  ▓▓▓▓▓▓▓▓▓░ Flutter/Dart      90%
  ▓▓▓▓▓▓▓▓▓░ React/Next.js     90%
  ▓▓▓▓▓▓▓▓░░ Vue.js            80%
  ▓▓▓▓▓▓▓▓▓░ TypeScript        90%

BACKEND:
  ▓▓▓▓▓▓▓▓░░ Node.js/Express   85%
  ▓▓▓▓▓▓▓▓░░ Python/Django     85%
  ▓▓▓▓▓▓▓░░░ Java/Spring       75%
  ▓▓▓▓▓▓▓▓░░ PostgreSQL/MySQL  80%

DEVOPS:
  ▓▓▓▓▓▓▓▓░░ Docker            85%
  ▓▓▓▓▓▓▓░░░ Kubernetes        75%
  ▓▓▓▓▓▓▓▓░░ AWS/Azure         80%
  ▓▓▓▓▓▓▓░░░ CI/CD             75%
''');
        break;

      case 'contact':
        _addToHistory('success', '''
╔══════════════════════════════════════════════════════════════════╗
║                     CONTACT INFORMATION                          ║
╚══════════════════════════════════════════════════════════════════╝

📧 Email:      your.email@example.com
🐙 GitHub:     github.com/yourusername
💼 LinkedIn:   linkedin.com/in/yourusername
🐦 Twitter:    @yourusername
🌐 Website:    yourportfolio.com

📍 Location:   Available Worldwide (Remote)
⏰ Timezone:   UTC+0

Feel free to reach out for collaborations, job opportunities,
or just to say hi! I'm always open to interesting conversations.
''');
        break;

      case 'date':
        final now = DateTime.now();
        _addToHistory('output', '${now.toString().split('.')[0]} UTC');
        break;

      case 'echo':
        _addToHistory('output', args.join(' '));
        break;

      case 'cat':
        if (args.isEmpty) {
          _addToHistory('error', 'cat: missing file operand');
        } else if (args[0] == 'README.md') {
          _addToHistory('output', '''# Portfolio OS

Welcome to my interactive portfolio! This terminal emulates a
VOIDROOT OS environment to showcase my projects and skills.

## Quick Start
- Type 'help' to see all available commands
- Type 'about' to learn more about me
- Type 'projects' to view my work

## Features
- Real-time terminal emulation
- Interactive command system
- Professional VOIDROOT OS interface
- Dynamic system detection

Made with ❤️ using Flutter''');
        } else {
          _addToHistory('error', 'cat: ${args[0]}: No such file or directory');
        }
        break;

      case 'ifconfig':
        _addToHistory('output',
            '''eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.100  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::a00:27ff:fe4e:66a1  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:4e:66:a1  txqueuelen 1000  (Ethernet)
        RX packets 147329  bytes 123456789 (117.7 MiB)
        TX packets 98234   bytes 87654321 (83.5 MiB)

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)''');
        break;

      case 'ping':
        if (args.isEmpty) {
          _addToHistory('error', 'ping: usage: ping <host>');
        } else {
          _addToHistory(
              'output', '''PING ${args[0]} (93.184.216.34) 56(84) bytes of data.
64 bytes from ${args[0]} (93.184.216.34): icmp_seq=1 ttl=56 time=14.2 ms
64 bytes from ${args[0]} (93.184.216.34): icmp_seq=2 ttl=56 time=13.8 ms
64 bytes from ${args[0]} (93.184.216.34): icmp_seq=3 ttl=56 time=14.5 ms

--- ${args[0]} ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 13.823/14.167/14.502/0.279 ms''');
        }
        break;

      case 'nmap':
        if (args.isEmpty) {
          _addToHistory('error', 'nmap: usage: nmap <host>');
        } else {
          _addToHistory('success', '''Starting Nmap 7.94 ( https://nmap.org )
Nmap scan report for ${args[0]}
Host is up (0.014s latency).
Not shown: 996 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
443/tcp  open  https
3000/tcp open  ppp

Nmap done: 1 IP address (1 host up) scanned in 0.84 seconds''');
        }
        break;

      case 'history':
        final commands = _history
            .where((h) =>
                h['type'] == 'command' && h['content'].toString().isNotEmpty)
            .toList();
        final historyText = StringBuffer();
        for (var i = 0; i < commands.length; i++) {
          historyText.writeln('  ${i + 1}  ${commands[i]['content']}');
        }
        _addToHistory('output', historyText.toString().trim());
        break;

      default:
        _addToHistory('error', 'zsh: command not found: $cmd');
    }

    _controller.clear();
    _scrollToBottom();

    // Refocus the input field after command execution
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _addToHistory(String type, String content) {
    setState(() {
      _history.add({'type': type, 'content': content});
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'success':
        return const Color(0xFF00FF00);
      case 'error':
        return const Color(0xFFFF5555);
      case 'warning':
        return const Color(0xFFFFB86C);
      case 'ascii':
        return const Color(0xFF00D1FF);
      default:
        return const Color(0xFFF8F8F2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Container(
        color: const Color(0xFF0D1117), // VOIDROOT OS dark background
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final item = _history[index];
                  final type = item['type'] as String;
                  final content = item['content'] as String;

                  if (type == 'command') {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                          ),
                          children: [
                            TextSpan(
                              text: '┌──(',
                              style: TextStyle(color: Colors.green[400]),
                            ),
                            TextSpan(
                              text: '$_user',
                              style: const TextStyle(color: Color(0xFF00D1FF)),
                            ),
                            TextSpan(
                              text: '㉿',
                              style: TextStyle(color: Colors.green[400]),
                            ),
                            TextSpan(
                              text: _host,
                              style: const TextStyle(color: Color(0xFF00D1FF)),
                            ),
                            TextSpan(
                              text: ')-[',
                              style: TextStyle(color: Colors.green[400]),
                            ),
                            TextSpan(
                              text: _currentDir,
                              style: const TextStyle(color: Color(0xFF50FA7B)),
                            ),
                            TextSpan(
                              text: ']\n└─\$ ',
                              style: TextStyle(color: Colors.green[400]),
                            ),
                            TextSpan(
                              text: content,
                              style: const TextStyle(color: Color(0xFFF8F8F2)),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SelectableText(
                        content,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 13,
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                          color: _getColorForType(type),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            // Input prompt
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First line of prompt
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: '┌──(',
                        style: TextStyle(color: Colors.green[400]),
                      ),
                      TextSpan(
                        text: _user,
                        style: const TextStyle(color: Color(0xFF00D1FF)),
                      ),
                      TextSpan(
                        text: '㉿',
                        style: TextStyle(color: Colors.green[400]),
                      ),
                      TextSpan(
                        text: _host,
                        style: const TextStyle(color: Color(0xFF00D1FF)),
                      ),
                      TextSpan(
                        text: ')-[',
                        style: TextStyle(color: Colors.green[400]),
                      ),
                      TextSpan(
                        text: _currentDir,
                        style: const TextStyle(color: Color(0xFF50FA7B)),
                      ),
                      TextSpan(
                        text: ']',
                        style: TextStyle(color: Colors.green[400]),
                      ),
                    ],
                  ),
                ),
                // Second line with prompt and input field
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: '└─\$ ',
                            style: TextStyle(color: Colors.green[400]),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        autofocus: true,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 14,
                          color: const Color(0xFFF8F8F2),
                          height: 1.4,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: _handleCommand,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
