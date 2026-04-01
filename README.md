# Mehndi Designs - Flutter App

A beautiful, feature-rich Flutter application for browsing, saving, and sharing mehndi designs. This app has been converted from an Android Java app to Flutter with modern features and unique functionality.

##  Features

### Core Features
- **Splash Screen** - Beautiful animated splash with app branding
- **Design Browsing** - Browse mehndi designs across multiple categories
- **Smart Filtering** - Filter by category, difficulty level, and search query
- **Design Categories** - Hand designs, Foot designs, and Tutorials
- **Difficulty Levels** - Easy, Medium, Hard classifications

### Unique Features
- **Trending Section** - Discover popular designs with engagement metrics
- **Recent Uploads** - Stay updated with latest added designs
- **Advanced Search** - Full-text search across design titles and descriptions
- **Tutorial Support** - Step-by-step guides with visual instructions
- **Difficulty Indicators** - Color-coded difficulty badges (Easy, Medium, Hard)
- **Artist Credits** - Support for artist/creator information
- **Design Metadata** - Rich design information including:
  - View counts formatted as K, M notation
  - Upload time (relative time - "2 days ago")
  - Category and subcategory
  - Detailed descriptions
  - Multiple step tutorials

### Download & Sharing
- **Download Manager** - Download designs locally with progress tracking
- **Share Integration** - Share designs via native share sheet
- **Download History** - Track your downloaded designs
- **File Size Display** - Show download sizes in readable format (B, KB, MB, GB)

### Collections & Organization
- **Favorites System** - Mark and organize favorite designs
- **Collections** - Group designs into custom collections
- **Favorite Browsing** - Quick access to saved designs
- **Collection Management** - Create, edit, and manage design collections

##  Project Structure

```
lib/
├── models/
│   ├── mehndi_design.dart          # Design data model
│   ├── favorites_collection.dart   # Collections model
│   └── downloaded_design.dart      # Download tracking model
├── services/
│   ├── mehndi_data_service.dart    # Business logic & mock data
│   ├── permission_service.dart     # Permission handling
│   └── storage_service.dart        # Local storage management
├── screens/
│   ├── splash_screen.dart          # Animated splash screen
│   ├── home_screen.dart            # Main navigation hub
│   ├── designs_screen.dart         # Browse & filter designs
│   ├── design_detail_screen.dart   # Single design view
│   ├── favorites_screen.dart       # Saved favorites
│   └── downloads_screen.dart       # Download management
├── widgets/
│   ├── design_card.dart            # Reusable design card widget
│   └── design_detail_widget.dart   # Detail view components
├── utils/
│   ├── constants.dart              # Colors, strings, dimensions
│   ├── app_theme.dart              # Theme configuration
│   └── helpers.dart                # Utility functions
└── main.dart                        # App entry point
```

##  Getting Started

### Prerequisites
- Flutter 3.10.4+
- Dart 3.10.4+
- Android SDK or iOS SDK (for mobile deployment)

### Installation

1. **Navigate to the project directory:**
   ```bash
   cd mehndi_flutter
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

##  Dependencies

### Key Packages
- **permission_handler** - Handle storage & photo permissions
- **path_provider** - Access device storage paths
- **image_picker** - Pick images from device
- **cached_network_image** - Efficient image caching
- **share_plus** - Native share functionality
- **intl** - Internationalization and date formatting
- **google_fonts** - Beautiful custom fonts
- **shimmer** - Loading skeleton screens

##  Architecture & Design Patterns

### Design Patterns Used
1. **MVC Pattern** - Models, Services, and UI separated
2. **Singleton Pattern** - PermissionService, StorageService
3. **Repository Pattern** - MehndiDataService manages data access
4. **Widget Composition** - Reusable, composable widgets

##  Unique Implementation Features

### 1. Smart Search & Filtering
- Real-time search with multiple criteria
- Filter by category and difficulty
- Results update instantly as user types

### 2. Rich Design Metadata
- Relative time formatting ("2 days ago")
- Number formatting (1000 → 1K, 1000000 → 1M)
- Multiple subcategories per main category
- Tutorial content with step-by-step guides

### 3. Modern UI Patterns
- Color-coded difficulty levels (Green=Easy, Orange=Medium, Red=Hard)
- Animated splash screen with fade and slide transitions
- Responsive grid layout that adapts to device size
- Card-based design with consistent styling

### 4. Professional Storage Management
- Persistent favorites with JSON serialization
- Collection-based organization system
- Download metadata tracking
- Total storage calculation

##  Working with the Code

### Adding New Designs
Edit `lib/services/mehndi_data_service.dart` and add to `_designs` list:

```dart
MehndiDesign(
  id: '9',
  title: 'Your Design Title',
  imageUrl: 'your_image_url',
  category: 'hand',
  subcategory: 'bridal',
  difficulty: 'hard',
  likes: 100,
  createdAt: DateTime.now(),
  description: 'Your description',
  artist: 'Artist Name',
)
```

### Customizing Theme
Edit colors in `lib/utils/constants.dart` (AppColors class)

### Adding New Screens
1. Create screen in `lib/screens/`
2. Add route in `main.dart`
3. Add navigation in parent screen

## 🎓 Learning Opportunities

- Flutter best practices and patterns
- Responsive UI design
- Navigation and routing
- Local data persistence
- Permission handling
- Reusable component design
- Service/Repository patterns

##  Code Examples

### Searching Designs
```dart
final results = dataService.searchDesigns('bridal');
```

### Filtering by Difficulty
```dart
final easyDesigns = dataService.getDesignsByDifficulty('easy');
```

### Date Formatting
```dart
final timeAgo = DateHelper.getTimeAgo(design.createdAt);
```

### Number Formatting
```dart
final formatted = FormatHelper.formatNumber(1250); // "1.2K"
```

---

**Built with  using Flutter**
