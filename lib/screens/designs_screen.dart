import 'package:flutter/material.dart';
import '../models/mehndi_design.dart';
import '../services/mehndi_data_service.dart';
import '../utils/constants.dart';
import '../widgets/design_card.dart';

class DesignsScreen extends StatefulWidget {
  const DesignsScreen({Key? key}) : super(key: key);

  @override
  State<DesignsScreen> createState() => _DesignsScreenState();
}

class _DesignsScreenState extends State<DesignsScreen> {
  final MehndiDataService _dataService = MehndiDataService();
  late List<MehndiDesign> _allDesigns;
  late List<MehndiDesign> _filteredDesigns;
  
  String _selectedCategory = 'all';
  String _selectedDifficulty = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _allDesigns = _dataService.getAllDesigns();
    _filteredDesigns = _allDesigns;
  }

  void _applyFilters() {
    setState(() {
      _filteredDesigns = _allDesigns.where((design) {
        bool categoryMatch = _selectedCategory == 'all' ||
            design.category.toLowerCase() == _selectedCategory.toLowerCase();
        bool difficultyMatch = _selectedDifficulty == 'all' ||
            design.difficulty.toLowerCase() == _selectedDifficulty.toLowerCase();
        bool searchMatch = _searchQuery.isEmpty ||
            design.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (design.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

        return categoryMatch && difficultyMatch && searchMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: TextField(
            onChanged: (value) {
              _searchQuery = value;
              _applyFilters();
            },
            decoration: InputDecoration(
              hintText: 'Search designs...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                        _applyFilters();
                      },
                    )
                  : null,
            ),
          ),
        ),

        // Filters
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMedium,
          ),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                  ),
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('All Categories')),
                    ..._dataService.getCategories().map(
                      (category) => DropdownMenuItem(
                        value: category.toLowerCase(),
                        child: Text(AppStrings.capitalize(category)),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _selectedCategory = value;
                      _applyFilters();
                    }
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSmall),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDifficulty,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                  ),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text('All Levels'),
                    ),
                    DropdownMenuItem(
                      value: 'easy',
                      child: Text('Easy'),
                    ),
                    DropdownMenuItem(
                      value: 'medium',
                      child: Text('Medium'),
                    ),
                    DropdownMenuItem(
                      value: 'hard',
                      child: Text('Hard'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _selectedDifficulty = value;
                      _applyFilters();
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.paddingMedium),

        // Designs Grid
        Expanded(
          child: _filteredDesigns.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 64,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      Text(
                        AppStrings.noDesigns,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMedium,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: AppDimensions.paddingMedium,
                    mainAxisSpacing: AppDimensions.paddingMedium,
                  ),
                  itemCount: _filteredDesigns.length,
                  itemBuilder: (context, index) {
                    return DesignCard(
                      design: _filteredDesigns[index],
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/design-detail',
                          arguments: _filteredDesigns[index],
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}
