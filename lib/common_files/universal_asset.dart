import 'package:flutter/material.dart';

class UniversalAssetImage extends StatelessWidget {
  final String imageName; // e.g. "DadiGopi" or "top1.png"
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? fallback;

  const UniversalAssetImage({
    Key? key,
    required this.imageName,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallback,
  }) : super(key: key);

  String _cleanPath(String name) {
    if (name.startsWith('assets/img/')) return name;
    return 'assets/img/$name';
  }

  @override
  Widget build(BuildContext context) {
    final String base = _cleanPath(imageName);
    // Strip existing extension if passed
    final String cleanBase = base.replaceAll(RegExp(r'\.(png|jpg|jpeg|webp)$'), '');

    return Image.asset(
      '$cleanBase.png',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Fallback 1: try .jpg
        return Image.asset(
          '$cleanBase.jpg',
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            // Fallback 2: try .jpeg
            return Image.asset(
              '$cleanBase.jpeg',
              width: width,
              height: height,
              fit: fit,
              errorBuilder: (context, error, stackTrace) {
                // Final fallback: default placeholder icon
                return fallback ??
                    Container(
                      width: width,
                      height: height,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                    );
              },
            );
          },
        );
      },
    );
  }
}