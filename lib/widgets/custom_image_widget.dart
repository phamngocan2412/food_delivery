import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final String fallbackImageUrl;

  const CustomImageWidget({
    Key? key,
    required this.imageUrl,
    this.width = 60,
    this.height = 60,
    this.fit = BoxFit.cover,
    this.fallbackImageUrl =
        'https://images.unsplash.com/photo-1584824486509-112e4181ff6b?q=80&w=2940&auto=format&fit=crop',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? fallbackImageUrl,
      width: width,
      height: height,
      fit: fit,
      errorWidget: (context, url, error) => Image.network(
        fallbackImageUrl,
        fit: fit,
        width: width,
        height: height,
      ),
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
