import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ResumeWidget extends StatelessWidget {
  const ResumeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgPrimary,
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resume',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Experience',
              [
                _buildExperienceItem(
                  'Senior Developer',
                  'Company Name',
                  '2021 - Present',
                  'Led development of various projects using modern technologies.',
                ),
                _buildExperienceItem(
                  'Full Stack Developer',
                  'Previous Company',
                  '2019 - 2021',
                  'Developed and maintained web applications.',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Education',
              [
                _buildExperienceItem(
                  'Bachelor of Computer Science',
                  'University Name',
                  '2015 - 2019',
                  'Graduated with honors.',
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {/* Download PDF */},
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  'Download PDF',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildExperienceItem(
    String title,
    String company,
    String period,
    String description,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bgPanel.withOpacity(0.8),
            AppColors.bgPanel.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$company • $period',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
