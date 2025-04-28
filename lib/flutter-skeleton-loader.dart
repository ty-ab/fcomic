import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Skeleton Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageSkeletonDemo(),
    );
  }
}

class ImageSkeletonDemo extends StatelessWidget {
  const ImageSkeletonDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample list of image URLs
    final List<String> imageUrls = [
      'https://picsum.photos/seed/image1/500/300',
      'https://picsum.photos/seed/image2/500/300',
      'https://picsum.photos/seed/image3/500/300',
      'https://picsum.photos/seed/image4/500/300',
      'https://picsum.photos/seed/image5/500/300',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Skeleton Loading'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SkeletonImageCard(imageUrl: imageUrls[index]),
          );
        },
      ),
    );
  }
}

class SkeletonImageCard extends StatelessWidget {
  final String imageUrl;
  
  const SkeletonImageCard({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildSkeletonLoader(),
          errorWidget: (context, url, error) => const Center(
            child: Icon(Icons.error, color: Colors.red, size: 50),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.white,
      ),
    );
  }
}

// Basic implementation without external packages
class SimpleSkeletonImage extends StatelessWidget {
  final String imageUrl;
  
  const SimpleSkeletonImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          imageUrl,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded || frame != null) {
              return child;
            }
            return _buildBasicSkeletonLoader();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return _buildBasicSkeletonLoader();
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.error, color: Colors.red, size: 50),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBasicSkeletonLoader() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[300],
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
        ),
      ),
    );
  }
}

// Custom shimmer effect without external packages
class CustomShimmerEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const CustomShimmerEffect({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  _CustomShimmerEffectState createState() => _CustomShimmerEffectState();
}

class _CustomShimmerEffectState extends State<CustomShimmerEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
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
                Colors.grey[300]!,
                Colors.grey[100]!,
                Colors.grey[300]!,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}