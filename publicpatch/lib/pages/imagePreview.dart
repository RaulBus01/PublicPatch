import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImagePreviewPage extends StatelessWidget {
  const ImagePreviewPage({super.key, required this.picture});
  final XFile picture;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(picture.path)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Retake Picture'))
          ],
        ),
      )),
    );
  }
}
