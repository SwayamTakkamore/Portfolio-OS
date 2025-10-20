import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/app_colors.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1117),
      padding: const EdgeInsets.all(40),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section with glassmorphism
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated glow
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: AppColors.accent2.withOpacity(0.3),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  // Profile picture placeholder
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.accent, AppColors.accent2],
                      ),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.5),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Name with gradient
            Center(
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.accent, AppColors.accent2],
                ).createShader(bounds),
                child: const Text(
                  'Your Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.2),
                      AppColors.accent2.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: const Text(
                  '💻 Full Stack Developer & Security Enthusiast',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Stats cards
            Row(
              children: [
                Expanded(child: _buildStatCard('5+', 'Years Exp', Icons.work)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('50+', 'Projects', Icons.code)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('100%', 'Success', Icons.stars)),
              ],
            ),
            const SizedBox(height: 40),
            // About section
            _buildSectionHeader('📝 About Me', Icons.info),
            const SizedBox(height: 16),
            _buildGlassCard(
              child: const Text(
                'I am a passionate developer with experience in building beautiful and functional applications. '
                'I love working with modern technologies and creating intuitive user experiences. '
                'My journey in tech has been driven by curiosity and a desire to solve real-world problems through code.\n\n'
                'Specializing in full-stack development, cloud architecture, and cybersecurity, '
                'I bring a holistic approach to building robust and scalable solutions.',
                style: TextStyle(
                  color: Color(0xFFCDD6F4),
                  fontSize: 15,
                  height: 1.8,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Skills section
            _buildSectionHeader('🚀 Technical Skills', Icons.psychology),
            const SizedBox(height: 20),
            _buildSkillCategory('Frontend', [
              'Flutter/Dart',
              'React/Next.js',
              'Vue.js',
              'TypeScript',
              'HTML/CSS',
              'Tailwind',
            ]),
            const SizedBox(height: 16),
            _buildSkillCategory('Backend', [
              'Node.js',
              'Python',
              'Java/Spring',
              'PostgreSQL',
              'MongoDB',
              'Redis',
            ]),
            const SizedBox(height: 16),
            _buildSkillCategory('DevOps & Tools', [
              'Docker',
              'Kubernetes',
              'AWS/Azure',
              'Git/GitHub',
              'CI/CD',
              'Linux',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bgPanel.withOpacity(0.6),
            AppColors.bgPanel.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accent, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.accent, AppColors.accent2],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.bgPanel.withOpacity(0.4),
                AppColors.bgPanel.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSkillCategory(String category, List<String> skills) {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.15),
            AppColors.accent2.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            skill,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
