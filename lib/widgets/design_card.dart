import 'package:flutter/material.dart';
import '../models/mehndi_design.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class DesignCard extends StatefulWidget {
  final MehndiDesign design;
  final VoidCallback onTap;
  final bool isCompact;

  const DesignCard({
    Key? key,
    required this.design,
    required this.onTap,
    this.isCompact = false,
  }) : super(key: key);

  @override
  State<DesignCard> createState() => _DesignCardState();
}

class _DesignCardState extends State<DesignCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
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
                    // Placeholder & Image
                    Container(
                      color: AppColors.cardBg,
                      child: const Icon(
                        Icons.image,
                        size: 40,
                        color: AppColors.textHint,
                      ),
                    ),
                    // In a real app, use CachedNetworkImage
                    // CachedNetworkImage(
                    //   imageUrl: widget.design.imageUrl,
                    //   fit: BoxFit.cover,
                    // )

                    // Favorite Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: widget.design.isFavorite
                              ? AppColors.secondary
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.design.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_outline,
                          size: 16,
                          color: widget.design.isFavorite
                              ? Colors.white
                              : AppColors.secondary,
                        ),
                      ),
                    ),

                    // Difficulty Badge
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(widget.design.difficulty),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusSmall),
                        ),
                        child: Text(
                          FormatHelper.capitalize(widget.design.difficulty),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            if (!widget.isCompact)
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.design.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          FormatHelper.formatNumber(widget.design.likes),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const Spacer(),
                        Text(
                          FormatHelper.capitalize(widget.design.category),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
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
