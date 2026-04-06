import 'mehndi_design.dart';

class FavoriteCollection {
  final String id;
  final String name;
  final String? description;
  final List<String> designIds; // IDs of designs in this collection
  final DateTime createdAt;
  final String? coverImageUrl;

  FavoriteCollection({
    required this.id,
    required this.name,
    this.description,
    this.designIds = const [],
    required this.createdAt,
    this.coverImageUrl,
  });

  void addDesign(String designId) {
    if (!designIds.contains(designId)) {
      designIds.add(designId);
    }
  }

  void removeDesign(String designId) {
    designIds.remove(designId);
  }

  bool containsDesign(String designId) {
    return designIds.contains(designId);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'designIds': designIds,
      'createdAt': createdAt.toIso8601String(),
      'coverImageUrl': coverImageUrl,
    };
  }

  factory FavoriteCollection.fromJson(Map<String, dynamic> json) {
    return FavoriteCollection(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'],
      designIds: List<String>.from(json['designIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      coverImageUrl: json['coverImageUrl'],
    );
  }
}
