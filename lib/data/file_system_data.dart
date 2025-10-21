import '../models/file_system.dart';

/// Portfolio file system structure with real asset files
class PortfolioFileSystem {
  static final List<DriveItem> drives = [
    // C: Drive - Main Portfolio Drive
    DriveItem(
      name: 'C:',
      label: 'Portfolio',
      totalSpace: '100 GB',
      usedSpace: '42 GB',
      freeSpace: '58 GB',
      children: [
        // Resume Folder - All files load from assets
        FolderItem(
          name: 'Resume',
          children: [
            FileItem(
              name: 'aboutme.md',
              extension: '.md',
              fileType: FileType.markdown,
              content: '',
              assetPath: 'assets/resume/aboutme.md',
            ),
            FileItem(
              name: 'projects.md',
              extension: '.md',
              fileType: FileType.markdown,
              content: '',
              assetPath: 'assets/resume/projects.md',
            ),
            FileItem(
              name: 'achievements.md',
              extension: '.md',
              fileType: FileType.markdown,
              content: '',
              assetPath: 'assets/resume/achievements.md',
            ),
            FileItem(
              name: 'skills.md',
              extension: '.md',
              fileType: FileType.markdown,
              content: '',
              assetPath: 'assets/resume/skills.md',
            ),
            FileItem(
              name: 'experience.md',
              extension: '.md',
              fileType: FileType.markdown,
              content: '',
              assetPath: 'assets/resume/experience.md',
            ),
            FileItem(
              name: 'education.md',
              extension: '.md',
              fileType: FileType.markdown,
              content: '',
              assetPath: 'assets/resume/education.md',
            ),
            FileItem(
              name: 'certifications.md',
              extension: '.md',
              fileType: FileType.markdown,
              content: '',
              assetPath: 'assets/resume/certifications.md',
            ),
            FileItem(
              name: 'contact.md',
              extension: '.md',
              fileType: FileType.markdown,
              content: '',
              assetPath: 'assets/resume/contact.md',
            ),
          ],
        ),

        // Projects Folder
        FolderItem(
          name: 'Projects',
          children: [
            FolderItem(
              name: 'Web Development',
              children: [
                FileItem(
                  name: 'portfolio-website.md',
                  extension: '.md',
                  fileType: FileType.markdown,
                  content:
                      '# Portfolio Website\n\nMy personal portfolio built with Flutter Web...',
                ),
                FileItem(
                  name: 'ecommerce-platform.md',
                  extension: '.md',
                  fileType: FileType.markdown,
                  content:
                      '# E-Commerce Platform\n\nFull-stack e-commerce solution...',
                ),
              ],
            ),
            FolderItem(
              name: 'Mobile Apps',
              children: [
                FileItem(
                  name: 'task-manager.md',
                  extension: '.md',
                  fileType: FileType.markdown,
                  content:
                      '# Task Manager App\n\nCross-platform task management application...',
                ),
              ],
            ),
          ],
        ),

        // Documents Folder
        FolderItem(
          name: 'Documents',
          children: [
            FileItem(
              name: 'resume.md',
              extension: '.md',
              fileType: FileType.markdown,
              content:
                  '# Professional Resume\n\nDetailed resume in markdown format...',
            ),
            FileItem(
              name: 'cover-letter.md',
              extension: '.md',
              fileType: FileType.markdown,
              content: '# Cover Letter\n\nDear Hiring Manager...',
            ),
          ],
        ),
      ],
    ),

    // D: Drive - Personal Projects
    DriveItem(
      name: 'D:',
      label: 'Personal',
      totalSpace: '50 GB',
      usedSpace: '18 GB',
      freeSpace: '32 GB',
      children: [
        FolderItem(
          name: 'Blog Posts',
          children: [
            FileItem(
              name: 'flutter-tips.md',
              extension: '.md',
              fileType: FileType.markdown,
              content:
                  '# Flutter Development Tips\n\nUseful tips and tricks for Flutter...',
            ),
          ],
        ),
        FolderItem(
          name: 'Notes',
          children: [
            FileItem(
              name: 'ideas.txt',
              extension: '.txt',
              fileType: FileType.text,
              content:
                  'Project Ideas:\n- AI Assistant\n- Portfolio Generator\n- Code Snippet Manager',
            ),
          ],
        ),
      ],
    ),
  ];
}
