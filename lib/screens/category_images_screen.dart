import 'package:flutter/material.dart';
import '../models/henna_models.dart';
import '../services/firebase_image_service.dart';
import '../services/cache_service.dart';
import '../utils/constants.dart';
import '../widgets/henna_image_card.dart';

class CategoryImagesScreen extends StatefulWidget {
  final HennaCategory category;

  const CategoryImagesScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryImagesScreen> createState() => _CategoryImagesScreenState();
}

class _CategoryImagesScreenState extends State<CategoryImagesScreen> {
  final FirebaseImageService _firebaseService = FirebaseImageService();
  final CacheService _cacheService = CacheService();

  late ScrollController _scrollController;
  List<HennaImage> _images = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentOffset = 0;
  static const int _pageSize = 20;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData && _searchQuery.isEmpty) {
        _loadMoreImages();
      }
    }
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _currentOffset = 0;
      _images = [];
      _hasMoreData = true;
    });

    try {
      // Try to load from cache first
      final cached = await _cacheService
          .loadCachedImagesForCategory(widget.category.id);

      if (cached != null && cached.isNotEmpty) {
        if (mounted) {
          setState(() {
            _images = cached;
            _isLoading = false;
            _currentOffset = cached.length;
          });
        }
      } else {
        await _fetchFirstPage();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading images: $e')),
        );
      }
    }
  }

  Future<void> _fetchFirstPage() async {
    final images = await _firebaseService.getImagesByCategory(
      categoryId: widget.category.id,
      limit: _pageSize,
    );

    if (mounted) {
      setState(() {
        _images = images;
        _isLoading = false;
        _currentOffset = images.length;
        if (images.length < _pageSize) {
          _hasMoreData = false;
        }
      });
    }

    if (images.isNotEmpty) {
      _cacheService.cacheImagesForCategory(
        widget.category.id,
        images,
      );
    }
  }

  Future<void> _loadMoreImages() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() => _isLoadingMore = true);

    try {
      // Pass the last image ID to support pagination via startAfter (more efficient than offset)
      final lastImageId = _images.isNotEmpty ? _images.last.id : null;
      
      final newImages = await _firebaseService.getImagesByCategory(
        categoryId: widget.category.id,
        limit: _pageSize,
        lastImageId: lastImageId,
      );

      if (mounted) {
        setState(() {
          if (newImages.isEmpty || newImages.length < _pageSize) {
            _hasMoreData = false;
          }
          _images.addAll(newImages);
          _currentOffset += newImages.length;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingMore = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading more images: $e')),
        );
      }
    }
  }

  Future<void> _searchImages(String query) async {
    setState(() => _searchQuery = query);

    if (query.isEmpty) {
      await _loadInitialData();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final results = await _firebaseService.searchImages(
        query: query,
        categoryId: widget.category.id,
      );

      if (mounted) {
        setState(() {
          _images = results;
          _isLoading = false;
          _hasMoreData = false; 
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching images: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.category.name),
            Text(
              '${_images.length} images',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: TextField(
              onChanged: _searchImages,
              decoration: InputDecoration(
                hintText: 'Search in ${widget.category.name}...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchImages(''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _images.isEmpty
                    ? Center(
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
                              _searchQuery.isEmpty
                                  ? 'No images in this category'
                                  : 'No images found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingMedium,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: AppDimensions.paddingSmall,
                          mainAxisSpacing: AppDimensions.paddingSmall,
                        ),
                        itemCount: _images.length + (_isLoadingMore ? 2 : 0),
                        itemBuilder: (context, index) {
                          if (index >= _images.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return HennaImageCard(
                            image: _images[index],
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/image-viewer',
                                arguments: _images[index],
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
