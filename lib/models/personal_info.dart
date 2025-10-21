class PersonalInfo {
  final String fullName;
  final String role;
  final String tagline;
  final String bio;
  final String location;
  final String email;
  final String phone;
  final String github;
  final String linkedin;
  final String twitter;
  final String website;
  final String portfolio;
  final List<String> skills;
  final String experience;
  final String education;
  final String availability;
  final String profileImage;

  PersonalInfo({
    this.fullName = 'Your Full Name',
    this.role = 'Full Stack Developer',
    this.tagline = 'Building the future, one line of code at a time',
    this.bio =
        'A passionate developer who loves creating innovative solutions...',
    this.location = 'City, Country',
    this.email = 'your.email@example.com',
    this.phone = '+1 (123) 456-7890',
    this.github = 'github.com/yourusername',
    this.linkedin = 'linkedin.com/in/yourusername',
    this.twitter = '@yourusername',
    this.website = 'yourwebsite.com',
    this.portfolio = 'yourportfolio.com',
    this.skills = const [
      'Flutter & Dart',
      'React & Next.js',
      'Node.js & Express',
      'Python & Django',
      'PostgreSQL & MongoDB',
      'Docker & Kubernetes',
      'AWS & Azure',
      'Git & CI/CD'
    ],
    this.experience = '5+ years',
    this.education = 'Bachelor\'s in Computer Science',
    this.availability = 'Available for hire',
    this.profileImage = 'assets/profile.jpg',
  });

  PersonalInfo copyWith({
    String? fullName,
    String? role,
    String? tagline,
    String? bio,
    String? location,
    String? email,
    String? phone,
    String? github,
    String? linkedin,
    String? twitter,
    String? website,
    String? portfolio,
    List<String>? skills,
    String? experience,
    String? education,
    String? availability,
    String? profileImage,
  }) {
    return PersonalInfo(
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      tagline: tagline ?? this.tagline,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      github: github ?? this.github,
      linkedin: linkedin ?? this.linkedin,
      twitter: twitter ?? this.twitter,
      website: website ?? this.website,
      portfolio: portfolio ?? this.portfolio,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      availability: availability ?? this.availability,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'role': role,
      'tagline': tagline,
      'bio': bio,
      'location': location,
      'email': email,
      'phone': phone,
      'github': github,
      'linkedin': linkedin,
      'twitter': twitter,
      'website': website,
      'portfolio': portfolio,
      'skills': skills,
      'experience': experience,
      'education': education,
      'availability': availability,
      'profileImage': profileImage,
    };
  }

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      fullName: json['fullName'] ?? 'Your Name',
      role: json['role'] ?? 'Developer',
      tagline: json['tagline'] ?? '',
      bio: json['bio'] ?? '',
      location: json['location'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      github: json['github'] ?? '',
      linkedin: json['linkedin'] ?? '',
      twitter: json['twitter'] ?? '',
      website: json['website'] ?? '',
      portfolio: json['portfolio'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      experience: json['experience'] ?? '',
      education: json['education'] ?? '',
      availability: json['availability'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}
