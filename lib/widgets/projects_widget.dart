import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/app_colors.dart';
import '../data/projects_data.dart';

class ProjectsWidget extends StatefulWidget {
  const ProjectsWidget({super.key});

  @override
  State<ProjectsWidget> createState() => _ProjectsWidgetState();
}

class _ProjectsWidgetState extends State<ProjectsWidget> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1117),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accent, AppColors.accent2],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.folder, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              const Text(
                'Featured Projects',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Showcasing my best work and achievements',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                final isHovered = _hoveredIndex == index;

                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredIndex = index),
                  onExit: (_) => setState(() => _hoveredIndex = null),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.only(bottom: 20),
                    transform: Matrix4.identity()
                      ..translate(0.0, isHovered ? -4.0 : 0.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.bgPanel
                                    .withOpacity(isHovered ? 0.7 : 0.5),
                                AppColors.bgPanel
                                    .withOpacity(isHovered ? 0.5 : 0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isHovered
                                  ? AppColors.accent.withOpacity(0.6)
                                  : AppColors.accent.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: isHovered
                                ? [
                                    BoxShadow(
                                      color: AppColors.accent.withOpacity(0.2),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                    BoxShadow(
                                      color: AppColors.accent2.withOpacity(0.1),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.accent.withOpacity(0.2),
                                          AppColors.accent2.withOpacity(0.2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color:
                                            AppColors.accent.withOpacity(0.4),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      _getProjectIcon(index),
                                      color: AppColors.accent,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          project.title,
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          height: 3,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.accent,
                                                AppColors.accent2,
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Status badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color:
                                            AppColors.success.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: AppColors.success,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.success,
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'Live',
                                          style: TextStyle(
                                            color: AppColors.success,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                project.description,
                                style: const TextStyle(
                                  color: Color(0xFFCDD6F4),
                                  fontSize: 15,
                                  height: 1.7,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: project.technologies
                                    .map((tech) => _buildTechChip(tech))
                                    .toList(),
                              ),
                              if (project.githubUrl != null ||
                                  project.liveUrl != null) ...[
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    if (project.githubUrl != null)
                                      Expanded(
                                        child: _buildLinkButton(
                                          'View Code',
                                          Icons.code,
                                          () {/* Open GitHub URL */},
                                          isGithub: true,
                                        ),
                                      ),
                                    if (project.githubUrl != null &&
                                        project.liveUrl != null)
                                      const SizedBox(width: 16),
                                    if (project.liveUrl != null)
                                      Expanded(
                                        child: _buildLinkButton(
                                          'Live Demo',
                                          Icons.launch,
                                          () {/* Open Live URL */},
                                          isGithub: false,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getProjectIcon(int index) {
    final icons = [
      Icons.web,
      Icons.shopping_cart,
      Icons.security,
      Icons.smart_toy,
    ];
    return icons[index % icons.length];
  }

  Widget _buildTechChip(String tech) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.15),
            AppColors.accent2.withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Text(
        tech,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildLinkButton(
    String label,
    IconData icon,
    VoidCallback onTap, {
    required bool isGithub,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isGithub
                  ? [
                      AppColors.bgPanel.withOpacity(0.8),
                      AppColors.bgPanel.withOpacity(0.6),
                    ]
                  : [AppColors.accent, AppColors.accent2],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isGithub
                  ? AppColors.accent.withOpacity(0.5)
                  : Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isGithub
                    ? Colors.black.withOpacity(0.2)
                    : AppColors.accent.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isGithub ? AppColors.accent : Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: isGithub ? AppColors.accent : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
