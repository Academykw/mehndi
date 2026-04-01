import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/henna_models.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class HennaImageCard extends StatelessWidget {
  final HennaImage image;
  final VoidCallback onTap;
  final VoidCallback? onLike;
  final bool showDetails;

  const HennaImageCard({
    Key? key,
    required this.image,
    required this.onTap,
    this.onLike,
    this.showDetails = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
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
                    // Image
                    CachedNetworkImage(
                      imageUrl: image.imageUrl,
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
                    ),

                    // Overlay with stats on hover
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),

                    // Top right: Like button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onLike,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.favorite_outline,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ),

                    // Bottom: stats
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(
                          AppDimensions.paddingSmall,
                        ),
                        child: Wrap(
                          spacing: 8,
                          children: [
                            // Views
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white70,
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  FormatHelper.formatNumber(image.views),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),

                            // Likes
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 12,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  FormatHelper.formatNumber(image.likes),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Title and info
            if (showDetails)
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      image.title,
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 2),

                    // Artist
                    if (image.artist != null)
                      Text(
                        'by ${image.artist}',
                        style: Theme.of(context).textTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    const SizedBox(height: 2),

                    // Date
                    Text(
                      DateHelper.getTimeAgo(image.uploadedAt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
