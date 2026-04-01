import 'package:flutter/material.dart';
import '../models/mehndi_design.dart';
import '../services/mehndi_data_service.dart';
import '../utils/constants.dart';
import '../widgets/design_card.dart';
import 'designs_screen.dart';
import 'favorites_screen.dart';
import 'downloads_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  final MehndiDataService _dataService = MehndiDataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        elevation: 0,
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedTabIndex,
        children: [
          _buildHomeTab(),
          const DesignsScreen(),
          const FavoritesScreen(),
          const DownloadsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: (index) {
          setState(() => _selectedTabIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedTabIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedTabIndex == 1
                  ? Icons.collections
                  : Icons.collections_outlined,
            ),
            label: 'Designs',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedTabIndex == 2 ? Icons.favorite : Icons.favorite_outline,
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedTabIndex == 3
                  ? Icons.download
                  : Icons.download_outlined,
            ),
            label: 'Downloads',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Featured Carousel
          _buildFeaturedSection(),
          const SizedBox(height: AppDimensions.paddingLarge),

          // Trending Designs
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trending Now',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () =>
                      setState(() => _selectedTabIndex = 1),
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          _buildTrendingSection(),
          const SizedBox(height: AppDimensions.paddingLarge),

          // Recent Designs
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Uploads',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () =>
                      setState(() => _selectedTabIndex = 1),
                  child: const Text('See All'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          _buildRecentSection(),
          const SizedBox(height: AppDimensions.paddingLarge),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    final featured = _dataService.getTrendingDesigns(limit: 5);
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: featured.length,
        padEnds: false,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
            ),
            child: DesignCard(
              design: featured[index],
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/design-detail',
                  arguments: featured[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrendingSection() {
    final trending = _dataService.getTrendingDesigns(limit: 6);
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
        ),
        itemCount: trending.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.only(right: AppDimensions.paddingSmall),
            child: SizedBox(
              width: 140,
              child: DesignCard(
                design: trending[index],
                isCompact: true,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/design-detail',
                    arguments: trending[index],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecentSection() {
    final recent = _dataService.getRecentDesigns(limit: 6);
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
        ),
        itemCount: recent.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:
                const EdgeInsets.only(right: AppDimensions.paddingSmall),
            child: SizedBox(
              width: 140,
              child: DesignCard(
                design: recent[index],
                isCompact: true,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/design-detail',
                    arguments: recent[index],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
