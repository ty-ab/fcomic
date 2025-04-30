import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A custom widget that loads an image from a URL with a skeleton loading effect.
/// 
/// This widget shows a skeleton animation while the image is loading,
/// and handles error states gracefully.
class SkeletonImageLoader extends StatelessWidget {
  /// The URL of the image to load
  final String imageUrl;
  
  /// Height of the image container
  final double? height;
  
  /// Width of the image container
  final double? width;
  
  /// How to fit the image within its container
  final BoxFit fit;
  
  /// Border radius of the image container
  final BorderRadius borderRadius;
  
  /// Base color for the shimmer effect
  final Color shimmerBaseColor;
  
  /// Highlight color for the shimmer effect
  final Color shimmerHighlightColor;
  
  /// Widget to display if there's an error loading the image
  final Widget? errorWidget;
  
  /// Whether to use a card-like elevation effect
  final bool useElevation;
  
  /// The elevation amount when useElevation is true
  final double elevation;
  
  /// Creates a SkeletonImageLoader widget.
  const SkeletonImageLoader({
    super.key,
    required this.imageUrl,
    this.height = 200,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.shimmerBaseColor = const Color(0xFFE0E0E0),
    this.shimmerHighlightColor = const Color(0xFFF5F5F5),
    this.errorWidget,
    this.useElevation = false,
    this.elevation = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final Widget imageContent = ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        imageUrl,
        height: height,
        width: width ?? double.infinity,
        fit: fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return _buildSkeletonLoader();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return _buildSkeletonLoader();
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? Center(
            child: Container(
              height: height,
              width: width ?? double.infinity,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.grey[400], size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Image not available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (useElevation) {
      return Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: imageContent,
      );
    }

    return imageContent;
  }

  Widget _buildSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

/// A version of SkeletonImageLoader that doesn't depend on the shimmer package.
/// 
/// Use this if you want to avoid adding external dependencies.
class SimpleSkeletonImageLoader extends StatefulWidget {
  /// The URL of the image to load
  final String imageUrl;
  
  /// Height of the image container
  final double? height;
  
  /// Width of the image container
  final double? width;
  
  /// How to fit the image within its container
  final BoxFit fit;
  
  /// Border radius of the image container
  final BorderRadius borderRadius;
  
  /// Base color for the animation effect
  final Color baseColor;
  
  /// Highlight color for the animation effect
  final Color highlightColor;
  
  /// Widget to display if there's an error loading the image
  final Widget? errorWidget;
  
  /// Whether to use a card-like elevation effect
  final bool useElevation;
  
  /// The elevation amount when useElevation is true
  final double elevation;
  
  /// Duration of the shimmer animation
  final Duration animationDuration;

  /// Creates a SimpleSkeletonImageLoader widget.
  const SimpleSkeletonImageLoader({
    Key? key,
    required this.imageUrl,
    this.height = 200,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.errorWidget,
    this.useElevation = false,
    this.elevation = 4.0,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  _SimpleSkeletonImageLoaderState createState() => _SimpleSkeletonImageLoaderState();
}

class _SimpleSkeletonImageLoaderState extends State<SimpleSkeletonImageLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget imageContent = ClipRRect(
      borderRadius: widget.borderRadius,
      child: Image.network(
        widget.imageUrl,
        height: widget.height,
        width: widget.width ?? double.infinity,
        fit: widget.fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return _buildSkeletonLoader();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return _buildSkeletonLoader();
        },
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget ?? Center(
            child: Container(
              height: widget.height,
              width: widget.width ?? double.infinity,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.grey[400], size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Image not available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    if (widget.useElevation) {
      return Card(
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(borderRadius: widget.borderRadius),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: imageContent,
      );
    }

    return imageContent;
  }

  Widget _buildSkeletonLoader() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: Container(
            height: widget.height,
            width: widget.width ?? double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: widget.borderRadius,
            ),
          ),
        );
      },
    );
  }
}