class Movie {
  final String id;
  final String title;
  final String description;
  final String category;
  final String language;
  final String videoUrl;
  final String imageUrl;
  final DateTime createdAt;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.language,
    required this.videoUrl,
    required this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'language': language,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      language: map['language'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }
}
