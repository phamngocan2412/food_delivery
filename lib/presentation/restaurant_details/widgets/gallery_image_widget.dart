import 'package:flutter/material.dart';

import '../../../widgets/custom_image_widget.dart';

class GalleryImageWidget extends StatelessWidget {
  final String imageUrl;

  const GalleryImageWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        CustomImageWidget(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha(77),
                Colors.transparent,
                Colors.black.withAlpha(128),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
