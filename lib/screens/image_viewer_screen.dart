import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import '../models/henna_models.dart';
import '../services/firebase_image_service.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'dart:developer' as developer;

class ImageViewerScreen extends StatefulWidget {
  final HennaImage image;

  const ImageViewerScreen({
    super.key,
    required this.image,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  final FirebaseImageService _firebaseService = FirebaseImageService();
  late HennaImage _currentImage;
  bool _isLiked = false;
  bool _showDetails = true;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.image;
    _incrementViewCount();
  }

  Future<void> _incrementViewCount() async {
    try {
      await _firebaseService.incrementViewCount(_currentImage.id);
      // Update local view count
      if (!mounted) return;
      setState(() {
        _currentImage = HennaImage(
          id: _currentImage.id,
          categoryId: _currentImage.categoryId,
          title: _currentImage.title,
          imageUrl: _currentImage.imageUrl,
          description: _currentImage.description,
          views: _currentImage.views + 1,
          likes: _currentImage.likes,
          artist: _currentImage.artist,
          uploadedAt: _currentImage.uploadedAt,
          tags: _currentImage.tags,
          aspectRatio: _currentImage.aspectRatio,
        );
      });
    } catch (e) {
      developer.log('Error incrementing view count', error: e);
    }
  }

  Future<void> _toggleLike() async {
    try {
      setState(() => _isLiked = !_isLiked);

      if (_isLiked) {
        await _firebaseService.incrementLikeCount(_currentImage.id);
      } else {
        await _firebaseService.decrementLikeCount(_currentImage.id);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLiked = !_isLiked);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating like: $e')),
      );
    }
  }

  Future<void> _shareImage() async {
    try {
      await Share.share(
        'Check out this beautiful henna design: ${_currentImage.title}\n\n'
        '${_currentImage.description ?? ''}\n\n'
        'From Mehndi Designs App',
        subject: _currentImage.title,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _showDetails
          ? AppBar(
              backgroundColor: Colors.black87,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _isLiked ? Icons.favorite : Icons.favorite_outline,
                    color: _isLiked ? Colors.red : Colors.white,
                  ),
                  onPressed: _toggleLike,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: _shareImage,
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: () {
          setState(() => _showDetails = !_showDetails);
        },
        child: Stack(
          children: [
            // Image viewer with zoom
            PopScope(
              canPop: true,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                Navigator.of(context).pop();
              },
              child: Center(
                child: PhotoView(
                  imageProvider: CachedNetworkImageProvider(
                    _currentImage.imageUrl,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  enableRotation: false,
                  basePosition: Alignment.center,
                  loadingBuilder: (context, event) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: event == null
                            ? null
                            : event.cumulativeBytesLoaded /
                                (event.expectedTotalBytes ?? 1),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stacktrace) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white70,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Error loading image',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Bottom details panel
            if (_showDetails)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withAlpha((0.9 * 255).toInt()),
                        Colors.black.withAlpha((0.5 * 255).toInt()),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        _currentImage.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.paddingSmall),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Views
                          Row(
                            children: [
                              const Icon(
                                Icons.remove_red_eye,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                FormatHelper.formatNumber(_currentImage.views),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          // Likes
                          Row(
                            children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                FormatHelper.formatNumber(_currentImage.likes),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          // Date
                          Text(
                            DateHelper.getTimeAgo(_currentImage.uploadedAt),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppDimensions.paddingSmall),

                      // Artist
                      if (_currentImage.artist != null)
                        Text(
                          'by ${_currentImage.artist}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                      const SizedBox(height: AppDimensions.paddingSmall),

                      // Description
                      if (_currentImage.description != null)
                        Text(
                          _currentImage.description!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                      // Tags
                      if (_currentImage.tags != null &&
                          _currentImage.tags!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: AppDimensions.paddingSmall,
                          ),
                          child: Wrap(
                            spacing: 4,
                            children: _currentImage.tags!
                                .split(',')
                                .map((tag) => Chip(
                                  label: Text(
                                    tag.trim(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor:
                                      Colors.white.withAlpha((0.1 * 255).toInt()),
                                  side: const BorderSide(
                                    color: Colors.white30,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                ))
                                .toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            // Toggle hint
            if (!_showDetails)
              Positioned(
                bottom: AppDimensions.paddingLarge,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingMedium,
                      vertical: AppDimensions.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSmall),
                    ),
                    child: const Text(
                      'Tap to show details',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
