import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Widget? errorWidget;
  final Duration fadeInDuration;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = shimmerBaseColor ?? Colors.grey[300]!;
    final highlightColor = shimmerHighlightColor ?? Colors.grey[100]!;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: fadeInDuration,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.grey[400],
                  size: 24,
                ),
              ),
            ),
      ),
    );
  }
}

// Extension for the circular profile images with shimmer effect
class CircularCachedImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Color? borderColor;
  final double borderWidth;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;

  const CircularCachedImage({
    super.key,
    required this.imageUrl,
    this.size = 60.0,
    this.borderColor,
    this.borderWidth = 2.0,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: borderColor != null
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor!,
                width: borderWidth,
              ),
            )
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: shimmerBaseColor ?? Colors.grey[300]!,
            highlightColor: shimmerHighlightColor ?? Colors.grey[100]!,
            child: Container(
              width: size,
              height: size,
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: Center(
              child: Icon(
                Icons.person,
                color: Colors.grey[400],
                size: size / 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Grid item for product cards with shimmer effect
class ProductCachedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;

  const ProductCachedImage({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = 150.0,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return CachedImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(borderRadius),
      errorWidget: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey[400],
                size: 30,
              ),
              SizedBox(height: 8),
              Text(
                'Image not available',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Banner image with shimmer effect
class BannerCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? overlayContent;

  const BannerCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height = 180.0,
    this.borderRadius = 16.0,
    this.overlayContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          if (overlayContent != null) overlayContent!,
        ],
      ),
    );
  }
}
