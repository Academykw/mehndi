import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/henna_models.dart';
import 'dart:developer' as developer;

class FirebaseImageService {
  static final FirebaseImageService _instance = 
      FirebaseImageService._internal();

  factory FirebaseImageService() {
    return _instance;
  }

  FirebaseImageService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection names
  static const String categoriesCollection = 'henna_categories';
  static const String imagesCollection = 'henna_images';

  /// Get all henna categories
  Future<List<HennaCategory>> getCategories() async {
    try {
      final snapshot = await _firestore
          .collection(categoriesCollection)
          .orderBy('name')
          .get();

      return snapshot.docs
          .map((doc) => HennaCategory.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      developer.log('Error fetching categories: $e', error: e);
      rethrow;
    }
  }

  /// Get images for a specific category with pagination
  Future<List<HennaImage>> getImagesByCategory({
    required String categoryId,
    int limit = 20,
    String? lastImageId,
  }) async {
    try {
      Query query = _firestore
          .collection(imagesCollection)
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('uploadedAt', descending: true);

      if (lastImageId != null) {
        final lastDoc = await _firestore
            .collection(imagesCollection)
            .doc(lastImageId)
            .get();
        if (lastDoc.exists) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      final snapshot = await query.limit(limit).get();

      return snapshot.docs
          .map((doc) => HennaImage.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      developer.log('Error fetching images: $e', error: e);
      rethrow;
    }
  }

  /// Get all images for a category (for initial load/caching)
  Future<List<HennaImage>> getAllImagesForCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection(imagesCollection)
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('uploadedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => HennaImage.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      developer.log('Error fetching all images: $e', error: e);
      rethrow;
    }
  }

  /// Search images by title or tags
  Future<List<HennaImage>> searchImages({
    required String query,
    String? categoryId,
  }) async {
    try {
      Query queryRef = _firestore.collection(imagesCollection);

      if (categoryId != null) {
        queryRef = queryRef.where('categoryId', isEqualTo: categoryId);
      }

      final snapshot = await queryRef.get();

      final queryLower = query.toLowerCase();
      return snapshot.docs
          .where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final title = (data['title'] ?? '').toString().toLowerCase();
            final tags = (data['tags'] ?? '').toString().toLowerCase();
            return title.contains(queryLower) || 
                   tags.contains(queryLower);
          })
          .map((doc) => HennaImage.fromJson({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      developer.log('Error searching images: $e', error: e);
      return [];
    }
  }

  /// Increment view count
  Future<void> incrementViewCount(String imageId) async {
    try {
      await _firestore
          .collection(imagesCollection)
          .doc(imageId)
          .update({
        'views': FieldValue.increment(1),
      });
    } catch (e) {
      developer.log('Error incrementing view count: $e', error: e);
    }
  }

  /// Increment like count
  Future<void> incrementLikeCount(String imageId) async {
    try {
      await _firestore
          .collection(imagesCollection)
          .doc(imageId)
          .update({
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      developer.log('Error incrementing like count: $e', error: e);
    }
  }

  /// Decrement like count
  Future<void> decrementLikeCount(String imageId) async {
    try {
      await _firestore
          .collection(imagesCollection)
          .doc(imageId)
          .update({
        'likes': FieldValue.increment(-1),
      });
    } catch (e) {
      developer.log('Error decrementing like count: $e', error: e);
    }
  }
}
