import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/henna_models.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class CategoryCard extends StatelessWidget {
  final HennaCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusMedium),
                    topRight: Radius.circular(AppDimensions.radiusMedium),
                  ),
                  color: AppColors.cardBg,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image or icon
                    if (category.thumbnailUrl != null)
                      CachedNetworkImage(
                        imageUrl: category.thumbnailUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.cardBg,
                          child: const Icon(
                            Icons.image,
                            size: 40,
                            color: AppColors.textHint,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.cardBg,
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 40,
                            color: Colors.red[300],
                          ),
                        ),
                      )
                    else
                      Container(
                        color: AppColors.primaryLight,
                        child: Icon(
                          _getCategoryIcon(category.name),
                          size: 48,
                          color: AppColors.primary,
                        ),
                      ),

                    // Image count badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall,
                          ),
                        ),
                        child: Text(
                          category.imageCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category name
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Description
                  Text(
                    category.description,
                    style: Theme.of(context).textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('hand')) {
      return Icons.pan_tool_outlined;
    } else if (name.contains('foot')) {
      return Icons.directions_walk_outlined;
    } else if (name.contains('bridal')) {
      return Icons.favorite_outline;
    } else if (name.contains('traditional')) {
      return Icons.history_outlined;
    } else if (name.contains('modern')) {
      return Icons.lightbulb_outline;
    } else if (name.contains('arabic')) {
      return Icons.language_outlined;
    } else {
      return Icons.palette_outlined;
    }
  }
}
