class Project {
  final String title;
  final String description;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;
  final String? imageUrl;

  Project({
    required this.title,
    required this.description,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
    this.imageUrl,
  });
}
