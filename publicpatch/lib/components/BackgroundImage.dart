import 'package:flutter/material.dart';

class Backgroundimage extends StatelessWidget {
  final String imagePath;
  final double opacity;
  const Backgroundimage({super.key , required this.imagePath , required this.opacity});



  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(opacity), BlendMode.darken),
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }
}