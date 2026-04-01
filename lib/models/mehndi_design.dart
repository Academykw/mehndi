class MehndiDesign {
  final String id;
  final String title;
  final String imageUrl;
  final String category; // 'hand', 'foot', 'tutorial'
  final String subcategory; // 'bridal', 'party', 'simple', etc.
  final String difficulty; // 'easy', 'medium', 'hard'
  final int likes;
  final DateTime createdAt;
  final String? description;
  final List<String>? steps; // For tutorials
  final String? artist;
  bool isFavorite;
  bool isDownloaded;

  MehndiDesign({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    this.subcategory = 'general',
    this.difficulty = 'medium',
    this.likes = 0,
    required this.createdAt,
    this.description,
    this.steps,
    this.artist,
    this.isFavorite = false,
    this.isDownloaded = false,
  });

  // For JSON serialization (if you want to store locally)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'category': category,
      'subcategory': subcategory,
      'difficulty': difficulty,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'steps': steps,
      'artist': artist,
      'isFavorite': isFavorite,
      'isDownloaded': isDownloaded,
    };
  }

  factory MehndiDesign.fromJson(Map<String, dynamic> json) {
    return MehndiDesign(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      subcategory: json['subcategory'] ?? 'general',
      difficulty: json['difficulty'] ?? 'medium',
      likes: json['likes'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      description: json['description'],
      steps: json['steps'] != null ? List<String>.from(json['steps']) : null,
      artist: json['artist'],
      isFavorite: json['isFavorite'] ?? false,
      isDownloaded: json['isDownloaded'] ?? false,
    );
  }
}
