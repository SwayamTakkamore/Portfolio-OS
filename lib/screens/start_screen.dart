import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'boot_screen.dart';
import '../constants/app_colors.dart';
import '../services/audio_service.dart';

class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
  });
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  final List<Particle> particles = [];
  final AudioService _audioService = AudioService();
  bool _isHovered = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _generateParticles();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // AudioService is a singleton, don't dispose it here
    super.dispose();
  }

  void _generateParticles() {
    final random = math.Random();
    for (int i = 0; i < 20; i++) {
      particles.add(Particle(
        x: random.nextDouble() * 1920,
        y: random.nextDouble() * 1080,
        size: random.nextDouble() * 3 + 1,
        speedX: (random.nextDouble() - 0.5) * 0.5,
        speedY: (random.nextDouble() - 0.5) * 0.5,
      ));
    }
  }

  Future<void> _handleStart() async {
    // Play boot sound using the singleton service
    _audioService.playBootSound();

    // Small delay to ensure audio starts
    await Future.delayed(const Duration(milliseconds: 150));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const BootScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgPrimary,
              AppColors.bgPrimary.withOpacity(0.8),
              AppColors.accent.withOpacity(0.1),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                // Update particle positions
                for (var particle in particles) {
                  particle.x += particle.speedX;
                  particle.y += particle.speedY;

                  if (particle.x < 0) particle.x = screenSize.width;
                  if (particle.x > screenSize.width) particle.x = 0;
                  if (particle.y < 0) particle.y = screenSize.height;
                  if (particle.y > screenSize.height) particle.y = 0;
                }

                return CustomPaint(
                  size: screenSize,
                  painter: ParticlePainter(particles: particles),
                );
              },
            ),
            // Power button
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    child: GestureDetector(
                      onTap: _handleStart,
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          // Create smooth pulsing glow effect
                          final glowIntensity = (math.sin(
                                      _animationController.value *
                                          math.pi *
                                          2) +
                                  1) /
                              2;
                          final hoverGlow = _isHovered ? 1.0 : 0.6;

                          return Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.accent.withOpacity(
                                      0.3 * glowIntensity * hoverGlow),
                                  AppColors.accent.withOpacity(
                                      0.15 * glowIntensity * hoverGlow),
                                  AppColors.accent2.withOpacity(
                                      0.1 * glowIntensity * hoverGlow),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.4, 0.7, 1.0],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withOpacity(
                                      0.3 * glowIntensity * hoverGlow),
                                  blurRadius:
                                      30 + (20 * glowIntensity * hoverGlow),
                                  spreadRadius:
                                      5 + (10 * glowIntensity * hoverGlow),
                                ),
                                BoxShadow(
                                  color: AppColors.accent2.withOpacity(
                                      0.2 * glowIntensity * hoverGlow),
                                  blurRadius:
                                      50 + (30 * glowIntensity * hoverGlow),
                                  spreadRadius:
                                      2 + (8 * glowIntensity * hoverGlow),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                width: _isHovered ? 85 : 80,
                                height: _isHovered ? 85 : 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.bgPanel,
                                  border: Border.all(
                                    color: AppColors.accent,
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent.withOpacity(0.5),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.power_settings_new,
                                  size: _isHovered ? 42 : 40,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.7,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      "Press To Start\nThe Machine",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      canvas.drawCircle(
        Offset(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
