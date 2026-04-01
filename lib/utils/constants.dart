import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF9C27B0); // Purple
  static const Color primaryDark = Color(0xFF6A1B9A);
  static const Color primaryLight = Color(0xFFE1BEE7);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF6B9D); // Pink
  static const Color secondaryLight = Color(0xFFFFB6D9);

  // Neutral Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFF50057)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppStrings {
  // App Info
  static const String appName = 'Mehndi Designs';
  static const String appTagline = 'Beautiful Henna Designs';

  // Screens
  static const String splash = 'splash';
  static const String home = 'home';
  static const String designs = 'designs';
  static const String favorites = 'favorites';
  static const String downloads = 'downloads';
  static const String profile = 'profile';

  // Categories
  static const String hand = 'Hand';
  static const String foot = 'Foot';
  static const String tutorial = 'Tutorial';

  // Buttons
  static const String startBrowsing = 'Start Browsing';
  static const String rateApp = 'Rate App';
  static const String shareApp = 'Share App';
  static const String download = 'Download';
  static const String addToFavorites = 'Add to Favorites';
  static const String removeFromFavorites = 'Remove from Favorites';
  static const String share = 'Share';
  static const String delete = 'Delete';
  static const String confirm = 'Confirm';
  static const String cancel = 'Cancel';

  // Messages
  static const String noFavorites = 'No favorites yet';
  static const String noDownloads = 'No downloads yet';
  static const String noDesigns = 'No designs found';
  static const String permissionDenied = 'Permission Denied';
  static const String permissionRequired =
      'Storage permission is required to download designs';
  static const String deleteConfirmation = 'Are you sure you want to delete this?';
  static const String downloadSuccess = 'Downloaded successfully';
  static const String shareFailed = 'Failed to share';

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

class AppDimensions {
  // Padding
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Button Heights
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 56.0;
}

class AppDurations {
  static const Duration shortest = Duration(milliseconds: 150);
  static const Duration short = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration long = Duration(milliseconds: 800);
  static const Duration longest = Duration(milliseconds: 1200);
}
