import '../models/mehndi_design.dart';

class MehndiDataService {
  // Mock data - In a real app, this would come from an API or database
  static final List<MehndiDesign> _designs = [
    MehndiDesign(
      id: '1',
      title: 'Bridal Mehndi - Full Hand',
      imageUrl: 'https://via.placeholder.com/500x600?text=Bridal+Full+Hand',
      category: 'hand',
      subcategory: 'bridal',
      difficulty: 'hard',
      likes: 234,
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      description: 'Stunning full hand bridal mehndi with traditional patterns',
      artist: 'Mehndi Artist Studio',
    ),
    MehndiDesign(
      id: '2',
      title: 'Simple Daily Mehndi',
      imageUrl: 'https://via.placeholder.com/500x600?text=Simple+Mehndi',
      category: 'hand',
      subcategory: 'simple',
      difficulty: 'easy',
      likes: 456,
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      description: 'Quick and easy mehndi design for daily wear',
      artist: 'Creative Hands',
    ),
    MehndiDesign(
      id: '3',
      title: 'Glitter Party Mehndi',
      imageUrl: 'https://via.placeholder.com/500x600?text=Party+Mehndi',
      category: 'hand',
      subcategory: 'party',
      difficulty: 'medium',
      likes: 567,
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      description: 'Modern mehndi with glitter accents for parties',
      artist: 'Bella Designs',
    ),
    MehndiDesign(
      id: '4',
      title: 'Arabic Foot Mehndi',
      imageUrl: 'https://via.placeholder.com/500x600?text=Foot+Arabic',
      category: 'foot',
      subcategory: 'arabic',
      difficulty: 'medium',
      likes: 345,
      createdAt: DateTime.now().subtract(Duration(days: 4)),
      description: 'Traditional Arabic style foot mehndi',
      artist: 'Henna Experts',
    ),
    MehndiDesign(
      id: '5',
      title: 'Geometric Foot Design',
      imageUrl: 'https://via.placeholder.com/500x600?text=Geometric+Foot',
      category: 'foot',
      subcategory: 'geometric',
      difficulty: 'hard',
      likes: 289,
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      description: 'Contemporary geometric patterns for feet',
      artist: 'Modern Henna',
    ),
    MehndiDesign(
      id: '6',
      title: 'Mehndi Tutorial - Bridal',
      imageUrl: 'https://via.placeholder.com/500x600?text=Tutorial+Bridal',
      category: 'tutorial',
      subcategory: 'bridal',
      difficulty: 'medium',
      likes: 678,
      createdAt: DateTime.now().subtract(Duration(days: 7)),
      description: 'Step by step tutorial for bridal mehndi',
      steps: [
        'Start with base patterns on the dorsal side',
        'Add filler designs in between',
        'Draw the main focal design',
        'Add details and outlines',
        'Fill with darker shades',
        'Add glitter and embellishments'
      ],
      artist: 'Professional Workshop',
    ),
    MehndiDesign(
      id: '7',
      title: 'Peacock Design - Hand',
      imageUrl: 'https://via.placeholder.com/500x600?text=Peacock+Hand',
      category: 'hand',
      subcategory: 'traditional',
      difficulty: 'hard',
      likes: 445,
      createdAt: DateTime.now().subtract(Duration(days: 6)),
      description: 'Beautiful peacock motif for wedding henna',
      artist: 'Royal Henna',
    ),
    MehndiDesign(
      id: '8',
      title: 'Bridal Foot Mehndi',
      imageUrl: 'https://via.placeholder.com/500x600?text=Bridal+Foot',
      category: 'foot',
      subcategory: 'bridal',
      difficulty: 'hard',
      likes: 512,
      createdAt: DateTime.now().subtract(Duration(days: 8)),
      description: 'Complete bridal foot coverage with intricate patterns',
      artist: 'Elite Henna Studio',
    ),
  ];

  // Get all designs
  List<MehndiDesign> getAllDesigns() {
    return _designs;
  }

  // Get designs by category
  List<MehndiDesign> getDesignsByCategory(String category) {
    return _designs.where((design) => design.category == category).toList();
  }

  // Get designs by subcategory
  List<MehndiDesign> getDesignsBySubcategory(String subcategory) {
    return _designs
        .where((design) => design.subcategory == subcategory)
        .toList();
  }

  // Get designs by difficulty
  List<MehndiDesign> getDesignsByDifficulty(String difficulty) {
    return _designs.where((design) => design.difficulty == difficulty).toList();
  }

  // Search designs
  List<MehndiDesign> searchDesigns(String query) {
    final lowerQuery = query.toLowerCase();
    return _designs
        .where((design) =>
            design.title.toLowerCase().contains(lowerQuery) ||
            design.description?.toLowerCase().contains(lowerQuery) == true)
        .toList();
  }

  // Get single design by ID
  MehndiDesign? getDesignById(String id) {
    try {
      return _designs.firstWhere((design) => design.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get trending designs (sorted by likes)
  List<MehndiDesign> getTrendingDesigns({int limit = 5}) {
    final sorted = [..._designs]..sort((a, b) => b.likes.compareTo(a.likes));
    return sorted.take(limit).toList();
  }

  // Get recent designs
  List<MehndiDesign> getRecentDesigns({int limit = 5}) {
    final sorted = [..._designs]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }

  // Get unique categories
  List<String> getCategories() {
    final categories = <String>{};
    for (var design in _designs) {
      categories.add(design.category);
    }
    return categories.toList();
  }

  // Get unique subcategories for a category
  List<String> getSubcategories(String category) {
    final subcategories = <String>{};
    for (var design in _designs) {
      if (design.category == category) {
        subcategories.add(design.subcategory);
      }
    }
    return subcategories.toList();
  }
}
