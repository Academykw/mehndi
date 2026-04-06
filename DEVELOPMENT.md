# Development & Extension Guide

## Getting Started with Development

This guide helps you understand and extend the Mehndi Flutter app.

## 🏗️ Architecture Overview

### Layered Architecture
```
┌─────────────────────────────────────────┐
│          UI Layer (Screens)             │  - HomeScreen, DesignsScreen, etc.
├─────────────────────────────────────────┤
│        Widgets Layer (Components)       │  - DesignCard, DetailWidget, etc.
├─────────────────────────────────────────┤
│      Service Layer (Business Logic)     │  - MehndiDataService, StorageService
├─────────────────────────────────────────┤
│          Model Layer (Data)             │  - MehndiDesign, Collection, etc.
├─────────────────────────────────────────┤
│        Utilities & Helpers              │  - Constants, Themes, Formatters
└─────────────────────────────────────────┘
```

---

## 🔧 Common Development Tasks

### Task 1: Adding a New Mehndi Design

**Step 1**: Open `lib/services/mehndi_data_service.dart`

**Step 2**: Find the `_designs` list (around line 10)

**Step 3**: Add a new design:
```dart
MehndiDesign(
  id: '9',
  title: 'Flower Garden Mehndi',
  imageUrl: 'https://via.placeholder.com/500x600?text=Flower+Garden',
  category: 'hand',
  subcategory: 'floral',
  difficulty: 'medium',
  likes: 320,
  createdAt: DateTime.now().subtract(Duration(days: 1)),
  description: 'Beautiful floral patterns with delicate leaves',
  artist: 'Flora Designs',
),
```

**Step 4**: Run `flutter run` to see your design!

---

### Task 2: Changing App Colors

**Step 1**: Open `lib/utils/constants.dart`

**Step 2**: Find the `AppColors` class:
```dart
class AppColors {
  // Change these colors
  static const Color primary = Color(0xFF9C27B0);      // App primary color
  static const Color secondary = Color(0xFFFF6B9D);    // Secondary accent
  static const Color success = Color(0xFF4CAF50);      // Success messages
  // ... more colors
}
```

**Step 3**: Update hex color values
- Format: `Color(0xFFRRGGBB)`
- Example: `Color(0xFFFF5722)` is deep orange

**Step 4**: Hot reload (`r` in terminal) to see changes

---

### Task 3: Adding a New Filter Option

**Step 1**: Open `lib/services/mehndi_data_service.dart`

**Step 2**: Find `MehndiDesign` class in `models/mehndi_design.dart`

**Step 3**: Add new property:
```dart
final String region; // 'north', 'south', 'east', 'west'
```

**Step 4**: Add getter method to service:
```dart
List<MehndiDesign> getDesignsByRegion(String region) {
  return _designs.where((design) => design.region == region).toList();
}
```

**Step 5**: Update UI in `lib/screens/designs_screen.dart`:
```dart
String _selectedRegion = 'all';

// In build method, add dropdown
DropdownButton<String>(
  value: _selectedRegion,
  items: [
    const DropdownMenuItem(value: 'all', child: Text('All Regions')),
    const DropdownMenuItem(value: 'north', child: Text('North Indian')),
    // ... more regions
  ],
  onChanged: (value) {
    if (value != null) {
      _selectedRegion = value;
      _applyFilters();
    }
  },
)
```

---

### Task 4: Creating a New Screen

**Step 1**: Create new file `lib/screens/tutorials_screen.dart`:
```dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TutorialsScreen extends StatefulWidget {
  const TutorialsScreen({Key? key}) : super(key: key);

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tutorials Screen'),
    );
  }
}
```

**Step 2**: Import in `main.dart`:
```dart
import 'screens/tutorials_screen.dart';
```

**Step 3**: Add to routes:
```dart
routes: {
  '/home': (context) => const HomeScreen(),
  '/tutorials': (context) => const TutorialsScreen(),
},
```

**Step 4**: Add navigation in `home_screen.dart`:
```dart
// In bottom nav item
BottomNavigationBarItem(
  icon: const Icon(Icons.school),
  label: 'Tutorials',
),
```

---

### Task 5: Implementing Real API Integration

**Step 1**: Update `mehndi_data_service.dart`:

```dart
import 'package:http/http.dart' as http;

class MehndiDataService {
  static const String _baseUrl = 'https://api.example.com';

  // Replace mock data with API call
  Future<List<MehndiDesign>> getAllDesignsFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/designs'),
      );

      if (response.statusCode == 200) {
        final jsonList = jsonDecode(response.body) as List;
        return jsonList
            .map((json) => MehndiDesign.fromJson(json))
            .toList();
      }
      throw Exception('Failed to load designs');
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
```

**Step 2**: Update screens to use async data:
```dart
@override
void initState() {
  super.initState();
  _loadDesigns();
}

Future<void> _loadDesigns() async {
  final designs = await dataService.getAllDesignsFromAPI();
  setState(() => _filteredDesigns = designs);
}
```

---

## 🎨 UI/UX Customization

### Changing Fonts

**Step 1**: Open `lib/utils/app_theme.dart`

**Step 2**: Update TextTheme:
```dart
textTheme: const TextTheme(
  displayLarge: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'YourFont', // Add this
  ),
),
```

### Adjusting Spacing

**Step 1**: Open `lib/utils/constants.dart`

**Step 2**: Modify `AppDimensions`:
```dart
class AppDimensions {
  static const double paddingSmall = 8.0;    // Change to 12.0
  static const double paddingMedium = 16.0;  // Change to 20.0
  static const double paddingLarge = 24.0;   // Change to 32.0
}
```

### Custom Button Styles

Create in `lib/widgets/custom_buttons.dart`:
```dart
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
```

---

## 🔌 Adding State Management

### Option 1: Provider Package (Recommended for beginners)

**Step 1**: Add to `pubspec.yaml`:
```yaml
provider: ^6.1.0
```

**Step 2**: Create a provider:
```dart
// lib/providers/design_provider.dart
import 'package:flutter/material.dart';
import '../models/mehndi_design.dart';
import '../services/mehndi_data_service.dart';

class DesignProvider extends ChangeNotifier {
  final MehndiDataService _dataService = MehndiDataService();
  List<MehndiDesign> _designs = [];
  
  List<MehndiDesign> get designs => _designs;
  
  void loadDesigns() {
    _designs = _dataService.getAllDesigns();
    notifyListeners();
  }
}
```

**Step 3**: Wrap app in provider:
```dart
// In main.dart
return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => DesignProvider()),
  ],
  child: MaterialApp(...)
);
```

**Step 4**: Use in widgets:
```dart
// In screens
Consumer<DesignProvider>(
  builder: (context, provider, child) {
    return ListView(
      children: provider.designs.map((design) {
        return DesignCard(design: design);
      }).toList(),
    );
  },
)
```

---

## 💾 Database Integration (Hive)

### Step 1: Add Hive
```yaml
dependencies:
  hive: ^2.2.0
  hive_flutter: ^1.1.0
```

### Step 2: Create Adapter
```dart
// lib/models/hive_adapters.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'mehndi_design.dart';

void registerHiveAdapters() {
  Hive.registerAdapter(MehndiDesignAdapter());
}
```

### Step 3: Use in Service
```dart
class StorageService {
  late Box<MehndiDesign> _box;
  
  Future<void> init() async {
    _box = await Hive.openBox<MehndiDesign>('designs');
  }
  
  void saveDesign(MehndiDesign design) {
    _box.put(design.id, design);
  }
  
  List<MehndiDesign> getAllDesigns() {
    return _box.values.toList();
  }
}
```

---

## 🧪 Testing

### Unit Test Example

```dart
// test/services/mehndi_data_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mehndi_flutter/services/mehndi_data_service.dart';

void main() {
  group('MehndiDataService', () {
    test('searchDesigns returns matching results', () {
      final service = MehndiDataService();
      final results = service.searchDesigns('bridal');
      expect(results.isNotEmpty, true);
      expect(results.every((d) => d.title.contains('bridal')||
          d.description?.contains('bridal') == true), true);
    });

    test('getTrendingDesigns returns sorted by likes', () {
      final service = MehndiDataService();
      final trending = service.getTrendingDesigns();
      expect(trending.isNotEmpty, true);
      for (int i = 0; i < trending.length - 1; i++) {
        expect(trending[i].likes >= trending[i + 1].likes, true);
      }
    });
  });
}
```

### Widget Test Example

```dart
// test/widgets/design_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mehndi_flutter/widgets/design_card.dart';
import 'package:mehndi_flutter/models/mehndi_design.dart';

void main() {
  testWidgets('DesignCard displays design title', (WidgetTester tester) async {
    final design = MehndiDesign(
      id: '1',
      title: 'Test Design',
      imageUrl: 'url',
      category: 'hand',
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DesignCard(
            design: design,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test Design'), findsOneWidget);
  });
}
```

---

## 📦 Building for Production

### Android Build

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS Build

```bash
# Build for iOS
flutter build ios --release
```

---

## 🐛 Debugging Tips

### Enable Debug Logging

```dart
void main() {
  // Enable logging
  debugPrint('App started');
  runApp(const MehndiApp());
}

// In services
debugPrint('Loaded ${designs.length} designs');
```

### Use DevTools

```bash
flutter pub global activate devtools
devtools
```

Then connect your running app to see:
- Flutter widget tree
- Performance profiling
- Memory usage
- Network requests
- Logging

---

## 📚 Best Practices

### Code Organization
- ✅ Keep models in `lib/models/`
- ✅ Put business logic in `lib/services/`
- ✅ UI in `lib/screens/` and `lib/widgets/`
- ✅ Shared utilities in `lib/utils/`

### Naming Conventions
- ✅ Classes: `PascalCase` (e.g., `MehndiDesign`)
- ✅ Variables: `camelCase` (e.g., `totalDesigns`)
- ✅ Constants: `ALL_CAPS` or treat as final
- ✅ Private: Prefix with `_` (e.g., `_privateMethod`)

### Widget Guidelines
- ✅ StatelessWidget for immutable widgets
- ✅ StatefulWidget only when needed
- ✅ Extract reusable widgets
- ✅ Use const constructors for performance

---

## 🚀 Performance Optimization

### Reduce Rebuilds

```dart
// BAD - rebuilds entire widget tree
class BadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return MyWidget(); // Rebuilds every frame
      },
    );
  }
}

// GOOD - reuses const widget
class GoodWidget extends StatelessWidget {
  const GoodWidget();
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return const MyWidget(); // Reused efficiently
      },
    );
  }
}
```

### Image Optimization

```dart
// Use CachedNetworkImage instead of Image.network
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => const SizedBox(
    height: 200,
    child: Center(child: CircularProgressIndicator()),
  ),
  errorWidget: (context, url, error) => const Icon(Icons.error),
)
```

---

## 📞 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Architecture Patterns](https://flutter.dev/docs/development/architecture)
- [Flutter Performance Guide](https://flutter.dev/docs/perf)

---

**Happy Coding! 🎉**
