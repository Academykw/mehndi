import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/design_detail_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/category_images_screen.dart';
import 'screens/image_viewer_screen.dart';
import 'models/mehndi_design.dart';
import 'models/henna_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue anyway - app will work with cache but won't sync with Firebase
  }

  runApp(const MehndiApp());
}

class MehndiApp extends StatelessWidget {
  const MehndiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/design-detail': (context) {
          final design =
              ModalRoute.of(context)?.settings.arguments as MehndiDesign?;
          if (design != null) {
            return DesignDetailScreen(design: design);
          }
          return const HomeScreen();
        },
        '/categories': (context) => const CategoriesScreen(),
        '/category-images': (context) {
          final category =
              ModalRoute.of(context)?.settings.arguments as HennaCategory?;
          if (category != null) {
            return CategoryImagesScreen(category: category);
          }
          return const CategoriesScreen();
        },
        '/image-viewer': (context) {
          final image =
              ModalRoute.of(context)?.settings.arguments as HennaImage?;
          if (image != null) {
            return ImageViewerScreen(image: image);
          }
          return const CategoriesScreen();
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/design-detail') {
          final design = settings.arguments as MehndiDesign?;
          if (design != null) {
            return MaterialPageRoute(
              builder: (context) => DesignDetailScreen(design: design),
            );
          }
        } else if (settings.name == '/category-images') {
          final category = settings.arguments as HennaCategory?;
          if (category != null) {
            return MaterialPageRoute(
              builder: (context) => CategoryImagesScreen(category: category),
            );
          }
        } else if (settings.name == '/image-viewer') {
          final image = settings.arguments as HennaImage?;
          if (image != null) {
            return MaterialPageRoute(
              builder: (context) => ImageViewerScreen(image: image),
            );
          }
        }
        return null;
      },
    );
  }
}
