import 'package:flutter/material.dart';
import '../models/henna_models.dart';
import '../services/firebase_image_service.dart';
import '../services/cache_service.dart';
import '../utils/constants.dart';
import '../widgets/category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FirebaseImageService _firebaseService = FirebaseImageService();
  final CacheService _cacheService = CacheService();
  
  late Future<List<HennaCategory>> _categories;
  List<HennaCategory> _cachedCategories = [];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    // Try to load from cache first
    final cached = await _cacheService.loadCachedCategories();
    
    if (cached != null) {
      setState(() {
        _cachedCategories = cached;
      });
    }

    // Always fetch fresh data from Firebase
    _categories = _firebaseService.getCategories().then((freshCategories) {
      // Cache the fresh data
      _cacheService.cacheCategories(freshCategories);
      if (mounted) {
        setState(() {
          _cachedCategories = freshCategories;
        });
      }
      return freshCategories;
    });
  }

  Future<void> _refreshCategories() async {
    setState(() => _isRefreshing = true);
    try {
      await _cacheService.clearAllCache();
      await _loadCategories();
    } finally {
      setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Henna Categories'),
        elevation: 0,
        actions: [
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _refreshCategories,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<HennaCategory>>(
        future: _categories,
        builder: (context, snapshot) {
          // Show cached data while loading
          if (!snapshot.hasData && _cachedCategories.isNotEmpty) {
            return _buildCategoriesGrid(_cachedCategories);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _cachedCategories.isNotEmpty
                ? _buildCategoriesGrid(_cachedCategories)
                : const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    'Error loading categories',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                  ElevatedButton(
                    onPressed: _refreshCategories,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  Text(
                    'No categories found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return _buildCategoriesGrid(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildCategoriesGrid(List<HennaCategory> categories) {
    return RefreshIndicator(
      onRefresh: _refreshCategories,
      child: GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingMedium),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: AppDimensions.paddingMedium,
          mainAxisSpacing: AppDimensions.paddingMedium,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            category: categories[index],
            onTap: () {
              Navigator.of(context).pushNamed(
                '/category-images',
                arguments: categories[index],
              );
            },
          );
        },
      ),
    );
  }
}
