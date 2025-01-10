import 'package:flutter/material.dart';

class GalleryView extends StatelessWidget {
  final List<String> imageUrls;

  const GalleryView({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.1,
                maxScale: 5.0,
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
