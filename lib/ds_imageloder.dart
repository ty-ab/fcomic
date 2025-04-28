import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Color skeletonBaseColor;
  final Color skeletonHighlightColor;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final bool showSkeleton;

  const CustomImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.skeletonBaseColor = const Color(0xFFE0E0E0),
    this.skeletonHighlightColor = const Color(0xFFF5F5F5),
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.showSkeleton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: fadeInDuration,
        placeholder: (context, url) => showSkeleton
            ? _buildSkeleton(context)
            : Container(color: skeletonBaseColor),
        errorWidget: (context, url, error) =>
            errorWidget ?? _buildErrorWidget(context),
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: skeletonBaseColor,
      highlightColor: skeletonHighlightColor,
      child: Container(
        width: width,
        height: height,
        color: skeletonBaseColor,
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: skeletonBaseColor,
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey[400],
          size: 40,
        ),
      ),
    );
  }
}