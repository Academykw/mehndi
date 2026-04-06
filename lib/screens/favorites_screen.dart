import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // TODO: Integrate with real favorites data
  final List<String> _favorites = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _favorites.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.favorite_outline,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  AppStrings.noFavorites,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to designs tab
                  },
                  child: const Text('Browse Designs'),
                ),
              ],
            )
          : const Text('Favorites content here'),
    );
  }
}
