import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/personal_info.dart';
import '../constants/app_colors.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({super.key});

  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  late PersonalInfo _personalInfo;
  bool _isEditing = false;

  // Controllers for form fields
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _taglineController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _githubController;
  late TextEditingController _linkedinController;
  late TextEditingController _twitterController;
  late TextEditingController _websiteController;
  late TextEditingController _portfolioController;
  late TextEditingController _experienceController;
  late TextEditingController _educationController;
  late TextEditingController _availabilityController;
  late TextEditingController _skillsController;

  @override
  void initState() {
    super.initState();
    _personalInfo = PersonalInfo();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: _personalInfo.fullName);
    _roleController = TextEditingController(text: _personalInfo.role);
    _taglineController = TextEditingController(text: _personalInfo.tagline);
    _bioController = TextEditingController(text: _personalInfo.bio);
    _locationController = TextEditingController(text: _personalInfo.location);
    _emailController = TextEditingController(text: _personalInfo.email);
    _phoneController = TextEditingController(text: _personalInfo.phone);
    _githubController = TextEditingController(text: _personalInfo.github);
    _linkedinController = TextEditingController(text: _personalInfo.linkedin);
    _twitterController = TextEditingController(text: _personalInfo.twitter);
    _websiteController = TextEditingController(text: _personalInfo.website);
    _portfolioController = TextEditingController(text: _personalInfo.portfolio);
    _experienceController = TextEditingController(text: _personalInfo.experience);
    _educationController = TextEditingController(text: _personalInfo.education);
    _availabilityController = TextEditingController(text: _personalInfo.availability);
    _skillsController = TextEditingController(text: _personalInfo.skills.join(', '));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _taglineController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _twitterController.dispose();
    _websiteController.dispose();
    _portfolioController.dispose();
    _experienceController.dispose();
    _educationController.dispose();
    _availabilityController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      _personalInfo = PersonalInfo(
        fullName: _nameController.text,
        role: _roleController.text,
        tagline: _taglineController.text,
        bio: _bioController.text,
        location: _locationController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        github: _githubController.text,
        linkedin: _linkedinController.text,
        twitter: _twitterController.text,
        website: _websiteController.text,
        portfolio: _portfolioController.text,
        experience: _experienceController.text,
        education: _educationController.text,
        availability: _availabilityController.text,
        skills: _skillsController.text.split(',').map((s) => s.trim()).toList(),
      );
      _isEditing = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile updated successfully!',
          style: GoogleFonts.jetBrainsMono(),
        ),
        backgroundColor: const Color(0xFF00FF00),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _initializeControllers(); // Reset to saved values
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D1117),
      child: Column(
        children: [
          // Header with Edit/Save buttons
          _buildHeader(),
          // Content
          Expanded(
            child: _isEditing ? _buildEditForm() : _buildViewMode(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withOpacity(0.1),
            AppColors.accent2.withOpacity(0.1),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.accent.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.person,
            color: AppColors.accent,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            _isEditing ? 'Edit Personal Information' : 'Personal Information',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (_isEditing) ...[
            _buildActionButton(
              'Cancel',
              Icons.close,
              Colors.red,
              _cancelEdit,
            ),
            const SizedBox(width: 12),
            _buildActionButton(
              'Save',
              Icons.check,
              const Color(0xFF00FF00),
              _saveChanges,
            ),
          ] else
            _buildActionButton(
              'Edit',
              Icons.edit,
              AppColors.accent,
              () => setState(() => _isEditing = true),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.3),
                color.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.jetBrainsMono(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          _buildProfileHeader(),
          const SizedBox(height: 32),
          
          // Quick Info Cards
          _buildQuickInfoGrid(),
          const SizedBox(height: 32),
          
          // Bio Section
          _buildSection('About Me', _personalInfo.bio, Icons.article),
          const SizedBox(height: 24),
          
          // Skills Section
          _buildSkillsSection(),
          const SizedBox(height: 24),
          
          // Contact Information
          _buildContactSection(),
          const SizedBox(height: 24),
          
          // Social Links
          _buildSocialSection(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bgPanel.withOpacity(0.8),
            AppColors.bgPanel.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Profile Image
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.accent, AppColors.accent2],
              ),
              border: Border.all(
                color: AppColors.accent,
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 24),
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _personalInfo.fullName,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _personalInfo.role,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 18,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _personalInfo.tagline,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatusBadge(_personalInfo.availability),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF00FF00).withOpacity(0.3),
            const Color(0xFF00FF00).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00FF00),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF00FF00),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            status,
            style: GoogleFonts.jetBrainsMono(
              color: const Color(0xFF00FF00),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            Icons.work,
            'Experience',
            _personalInfo.experience,
            AppColors.accent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            Icons.school,
            'Education',
            _personalInfo.education,
            AppColors.accent2,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            Icons.location_on,
            'Location',
            _personalInfo.location,
            const Color(0xFF50FA7B),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgPanel.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgPanel.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgPanel.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, color: AppColors.accent, size: 24),
              const SizedBox(width: 12),
              Text(
                'Technical Skills',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _personalInfo.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.3),
                      AppColors.accent2.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  skill,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgPanel.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.contact_mail, color: AppColors.accent, size: 24),
              const SizedBox(width: 12),
              Text(
                'Contact Information',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContactItem(Icons.email, 'Email', _personalInfo.email),
          _buildContactItem(Icons.phone, 'Phone', _personalInfo.phone),
          _buildContactItem(Icons.language, 'Website', _personalInfo.website),
          _buildContactItem(Icons.work, 'Portfolio', _personalInfo.portfolio),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent2, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgPanel.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.share, color: AppColors.accent, size: 24),
              const SizedBox(width: 12),
              Text(
                'Social Links',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSocialLink(Icons.code, 'GitHub', _personalInfo.github),
          _buildSocialLink(Icons.business, 'LinkedIn', _personalInfo.linkedin),
          _buildSocialLink(Icons.alternate_email, 'Twitter', _personalInfo.twitter),
        ],
      ),
    );
  }

  Widget _buildSocialLink(IconData icon, String platform, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent2, size: 20),
          const SizedBox(width: 12),
          Text(
            '$platform: ',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            url,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13,
              color: AppColors.accent,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit your personal information below:',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildFormSection('Basic Information', [
            _buildTextField('Full Name', _nameController, Icons.person),
            _buildTextField('Role/Title', _roleController, Icons.work),
            _buildTextField('Tagline', _taglineController, Icons.format_quote),
            _buildTextField('Bio', _bioController, Icons.article, maxLines: 4),
          ]),
          
          _buildFormSection('Location & Availability', [
            _buildTextField('Location', _locationController, Icons.location_on),
            _buildTextField('Experience', _experienceController, Icons.schedule),
            _buildTextField('Education', _educationController, Icons.school),
            _buildTextField('Availability Status', _availabilityController, Icons.check_circle),
          ]),
          
          _buildFormSection('Contact Information', [
            _buildTextField('Email', _emailController, Icons.email),
            _buildTextField('Phone', _phoneController, Icons.phone),
            _buildTextField('Website', _websiteController, Icons.language),
            _buildTextField('Portfolio', _portfolioController, Icons.work),
          ]),
          
          _buildFormSection('Social Links', [
            _buildTextField('GitHub', _githubController, Icons.code),
            _buildTextField('LinkedIn', _linkedinController, Icons.business),
            _buildTextField('Twitter', _twitterController, Icons.alternate_email),
          ]),
          
          _buildFormSection('Skills', [
            _buildTextField(
              'Skills (comma-separated)',
              _skillsController,
              Icons.stars,
              maxLines: 3,
            ),
          ]),
          
          const SizedBox(height: 32),
          
          // Save/Cancel buttons at bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionButton('Cancel', Icons.close, Colors.red, _cancelEdit),
              const SizedBox(width: 16),
              _buildActionButton('Save Changes', Icons.check, const Color(0xFF00FF00), _saveChanges),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(String title, List<Widget> fields) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgPanel.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 16),
          ...fields,
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accent2, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.bgPrimary.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.accent.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.accent.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.accent,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
