import '../models/project.dart';

final List<Project> projects = [
  Project(
    title: 'Portfolio OS',
    description:
        'An interactive portfolio designed to look like an operating system with a beautiful Linux-inspired UI.',
    technologies: ['Flutter', 'Dart', 'Provider', 'Material Design'],
    githubUrl: 'https://github.com/yourusername/portfolio',
    liveUrl: 'https://yourportfolio.com',
  ),
  Project(
    title: 'Project 2',
    description: 'Description of your second project',
    technologies: ['Technology 1', 'Technology 2'],
    githubUrl: 'https://github.com/yourusername/project2',
  ),
  Project(
    title: 'Project 3',
    description: 'Description of your third project',
    technologies: ['Technology 1', 'Technology 2'],
    liveUrl: 'https://project3.com',
  ),
];
