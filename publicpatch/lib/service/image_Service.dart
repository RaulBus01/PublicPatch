import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class ImageService {
  final String cloudName = 'dl88qd6uc';
  final String uploadPreset = 'public'; // Add your upload preset
  final String apiKey = '633537893989813';
  final String apiSecret = 'I_78QQfOMh-Y0MLb410g1oL2Too'; // Add your API key
  final cloudinary = CloudinaryPublic(
    'dl88qd6uc',
    'public', // Make sure this upload preset exists and is unsigned
    cache: false,
  );

  Future<List<String>> uploadImages(List<File> images) async {
    if (images.isEmpty) return [];

    try {
      List<String> uploadedUrls = [];

      // Upload images sequentially to avoid rate limiting
      for (var image in images) {
        print('Uploading image: ${image.path}');

        // Add delay between uploads
        if (uploadedUrls.isNotEmpty) {
          await Future.delayed(Duration(seconds: 1));
        }

        final response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path,
              resourceType: CloudinaryResourceType.Image,
              folder: 'reports',
              tags: ['reports']),
        );

        print('Upload successful: ${response.secureUrl}');
        uploadedUrls.add(response.secureUrl);
      }

      return uploadedUrls;
    } on CloudinaryException catch (e) {
      print('Cloudinary error details: ${e.message}');
      throw Exception('Cloudinary upload failed: ${e.message}');
    } catch (e) {
      print('Upload error details: $e');
      throw Exception('Failed to upload images');
    }
  }
}
