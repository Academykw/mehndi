import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/mehndi_design.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class DesignDetailWidget extends StatefulWidget {
  final MehndiDesign design;

  const DesignDetailWidget({
    Key? key,
    required this.design,
  }) : super(key: key);

  @override
  State<DesignDetailWidget> createState() => _DesignDetailWidgetState();
}

class _DesignDetailWidgetState extends State<DesignDetailWidget> {
  late MehndiDesign _design;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _design = widget.design;
  }

  Future<void> _download() async {
    setState(() => _isDownloading = true);

    // Simulate download
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isDownloading = false;
      _design.isDownloaded = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.downloadSuccess),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _share() async {
    try {
      await Share.share(
        'Check out this amazing mehndi design: ${_design.title}',
        subject: AppStrings.appName,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.shareFailed),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _toggleFavorite() {
    setState(() {
      _design.isFavorite = !_design.isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _design.isFavorite
              ? 'Added to favorites'
              : 'Removed from favorites',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            width: double.infinity,
            height: 300,
            color: AppColors.cardBg,
            child: const Icon(
              Icons.image,
              size: 80,
              color: AppColors.textHint,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Info Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _design.title,
                            style:
                                Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(_design.difficulty),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  FormatHelper.capitalize(
                                    _design.difficulty,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  FormatHelper.capitalize(_design.category),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: _toggleFavorite,
                          icon: Icon(
                            _design.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            color: _design.isFavorite
                                ? AppColors.secondary
                                : AppColors.textSecondary,
                            size: 28,
                          ),
                        ),
                        Text(
                          FormatHelper.formatNumber(_design.likes),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.paddingMedium),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      Icons.remove_red_eye_outlined,
                      '${_design.likes}',
                      'Views',
                    ),
                    _buildStatItem(
                      context,
                      Icons.calendar_today,
                      DateHelper.getTimeAgo(_design.createdAt),
                      'Uploaded',
                    ),
                    if (_design.artist != null)
                      _buildStatItem(
                        context,
                        Icons.person,
                        _design.artist!.split(' ').first,
                        'Artist',
                      ),
                  ],
                ),

                const SizedBox(height: AppDimensions.paddingLarge),

                // Description
                if (_design.description != null) ...[
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppDimensions.paddingSmall),
                  Text(
                    _design.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                ],

                // Steps (for tutorials)
                if (_design.steps != null && _design.steps!.isNotEmpty) ...[
                  Text(
                    'Step by Step Guide',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppDimensions.paddingMedium),
                  ..._design.steps!.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.paddingMedium,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.paddingMedium),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: AppDimensions.paddingSmall,
                              ),
                              child: Text(
                                entry.value,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLarge),
                ],

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isDownloading ? null : _download,
                        icon: _isDownloading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.download),
                        label: Text(
                          _design.isDownloaded
                              ? 'Downloaded'
                              : 'Download',
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),
                      OutlinedButton.icon(
                        onPressed: _share,
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
