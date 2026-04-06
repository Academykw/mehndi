# Firebase Features Integration

## New Screens Added

###1. **Categories Screen** (`/categories`)
Browse all henna design categories from Firebase.

**Features:**
- Grid view of categories (2 columns)
- Category thumbnail, name, and image count badge
- Cache-first loading (instant display)
- Manual refresh button
- Pull-to-refresh gesture support

**Access from code:**
```dart
Navigator.pushNamed(context, '/categories');
```

**Navigation:**
- Categories Screen → taps category → Category Images Screen

---

### 2. **Category Images Screen** (`/category-images`)
Browse individual henna designs within a category.

**Features:**
- 2-column grid view of henna images
- Search functionality to filter designs
- Infinite scroll pagination (20 items per page)
- Engagement stats (views, likes)
- Cache-first loading

**Access from code:**
```dart
Navigator.pushNamed(
  context,
  '/category-images',
  arguments: hennaCategory,  // HennaCategory object
);
```

**Parameters:**
- `hennaCategory` (HennaCategory): The category to display

**Navigation:**
- Category Images Screen → taps image → Image Viewer Screen

---

### 3. **Image Viewer Screen** (`/image-viewer`)
Full-screen image viewer with advanced features.

**Features:**
- Full-screen image display
- PhotoView zoom capability (pinch, double-tap)
- Toggle details panel (tap image)
- Like/unlike functionality (updates Firebase)
- Share design via native share sheet
- Engagement metrics display (views, likes, artist)
- View count auto-increments on load
- Tags displayed as chips

**Access from code:**
```dart
Navigator.pushNamed(
  context,
  '/image-viewer',
  arguments: hennaImage,  // HennaImage object
);
```

**Parameters:**
- `hennaImage` (HennaImage): The image to display

---

## Connecting to Home Screen

To add a button on the home screen that opens categories:

**In `home_screen.dart`:**
```dart
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/categories');
  },
  child: const Text('Browse Firebase Designs'),
)
```

Or add a new tab in home screen:
```dart
TabBar(
  tabs: const [
    Tab(text: 'Mock Designs'),
    Tab(text: 'Firebase Designs'),
  ],
)
```

---

## Firebase Services

### FirebaseImageService
Located: `lib/services/firebase_image_service.dart`

**Available Methods:**
```dart
// Get all categories
Future<List<HennaCategory>> getCategories()

// Get single category
Future<HennaCategory?> getCategoryById(String categoryId)

// Get paginated images in category (20 per page)
Future<List<HennaImage>> getImagesByCategory(
  String categoryId,
  {int limit = 20, int offset = 0}
)

// Get all images in category (for initial cache)
Future<List<HennaImage>> getAllImagesForCategory(String categoryId)

// Search designs
Future<List<HennaImage>> searchImages(
  String query,
  String categoryId
)

// Get trending designs (by likes)
Future<List<HennaImage>> getTrendingImages({int limit = 20})

// Track engagement
Future<void> incrementViewCount(String imageId)
Future<void> incrementLikeCount(String imageId)
Future<void> decrementLikeCount(String imageId)

// Get stats
Future<int> getImageCountForCategory(String categoryId)
Future<HennaImage?> getImageById(String imageId)
```

### CacheService
Located: `lib/services/cache_service.dart`

**Available Methods:**
```dart
// Cache/load categories
Future<void> cacheCategories(List<HennaCategory> categories)
Future<List<HennaCategory>?> loadCachedCategories()

// Cache/load images by category
Future<void> cacheImagesForCategory(
  String categoryId,
  List<HennaImage> images
)
Future<List<HennaImage>?> loadCachedImagesForCategory(String categoryId)

// Cache validation
Future<bool> isCacheOutdated(String categoryId)
Future<CachedImagesMetadata?> getCacheMetadata(String categoryId)

// Cache management
Future<void> clearCategoryCache(String categoryId)
Future<void> clearAllCache()
Future<int> getCacheSize()
```

---

## Data Models

### HennaCategory
```dart
class HennaCategory {
  final String id;
  final String name;
  final String description;
  final String? thumbnailUrl;
  final int imageCount;
  final DateTime createdAt;
  final String? icon;
}
```

### HennaImage
```dart
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
}
```

---

## Caching Behavior

**First Load:**
1. Try to load from local cache
2. Show cached data immediately
3. Fetch fresh data from Firestore
4. Update local cache if different

**Subsequent Loads (within 1 hour):**
- Load instantly from cache
- No Firebase query

**After 1 Hour:**
- Cache expires automatically
- Next load fetches fresh from Firestore
- Local cache updated

**Offline Mode:**
- App uses cached data
- "No internet" message shown
- Engagement actions (likes, views) stored locally
- Sync when online

---

## Example Implementation

### Add Firebase Designs Tab to Home Screen

```dart
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mehndi Designs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Collection'),
            Tab(text: 'Popular Designs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Existing designs screen
          const DesignsScreen(),
          // New Firebase categories screen
          const CategoriesScreen(),
        ],
      ),
    );
  }
}
```

---

## Troubleshooting

**Categories not loading?**
- Check Firebase configuration in `firebase_options.dart`
- Verify Firestore collections exist and have data
- Check internet connection
- App will still work with cached data

**Images not showing?**
- Verify image URLs are HTTPS and publicly accessible
- Check Firebase Storage permissions
- Verify `imageUrl` field in Firestore documents

**Search not working?**
- Ensure Firestore indexes are created (see FIREBASE_SETUP.md)
- Check tags field is populated in image documents

**Slow performance?**
- Pagination should show 20 images at a time
- Cache should be used for faster loads
- Check network speed and Firestore query performance

---

## Next Steps

1. Set up Firebase project (see FIREBASE_SETUP.md)
2. Create Firestore collections and data
3. Connect navigation in HomeScreen to CategoriesScreen
4. Test the complete flow:
   - Home → Categories → Images Grid → Full Viewer
5. Upload your henna design images
6. Deploy to production

For detailed Firebase setup instructions, see [FIREBASE_SETUP.md](./FIREBASE_SETUP.md).
