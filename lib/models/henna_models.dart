class HennaCategory {
  final String id;
  final String name;
  final String description;
  final String? thumbnailUrl;
  final int imageCount;
  final DateTime createdAt;
  final String? icon;

  HennaCategory({
    required this.id,
    required this.name,
    required this.description,
    this.thumbnailUrl,
    required this.imageCount,
    required this.createdAt,
    this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'imageCount': imageCount,
      'createdAt': createdAt.toIso8601String(),
      'icon': icon,
    };
  }

  factory HennaCategory.fromJson(Map<String, dynamic> json) {
    return HennaCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'],
      imageCount: json['imageCount'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      icon: json['icon'],
    );
  }
}

class HennaImage {
  final String id;
  final String categoryId;
  final String title;
  final String imageUrl;
  final String? description;
  final int views;
  final int likes;
  final String? artist;
  final DateTime uploadedAt;
  final String? tags;
  final double? aspectRatio;

  HennaImage({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.imageUrl,
    this.description,
    this.views = 0,
    this.likes = 0,
    this.artist,
    required this.uploadedAt,
    this.tags,
    this.aspectRatio,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'views': views,
      'likes': likes,
      'artist': artist,
      'uploadedAt': uploadedAt.toIso8601String(),
      'tags': tags,
      'aspectRatio': aspectRatio,
    };
  }

  factory HennaImage.fromJson(Map<String, dynamic> json) {
    return HennaImage(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'],
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      artist: json['artist'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      tags: json['tags'],
      aspectRatio: json['aspectRatio']?.toDouble(),
    );
  }
}

class CachedImagesMetadata {
  final String categoryId;
  final DateTime cachedAt;
  final int totalCount;
  final DateTime nextUpdateTime;

  CachedImagesMetadata({
    required this.categoryId,
    required this.cachedAt,
    required this.totalCount,
    required this.nextUpdateTime,
  });

  bool get isOutdated {
    return DateTime.now().isAfter(nextUpdateTime);
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'cachedAt': cachedAt.toIso8601String(),
      'totalCount': totalCount,
      'nextUpdateTime': nextUpdateTime.toIso8601String(),
    };
  }

  factory CachedImagesMetadata.fromJson(Map<String, dynamic> json) {
    return CachedImagesMetadata(
      categoryId: json['categoryId'] as String,
      cachedAt: DateTime.parse(json['cachedAt']),
      totalCount: json['totalCount'] as int,
      nextUpdateTime: DateTime.parse(json['nextUpdateTime']),
    );
  }
}
