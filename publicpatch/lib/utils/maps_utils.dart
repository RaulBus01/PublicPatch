import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:share_plus/share_plus.dart';

class MapUtils {
  MapUtils._();

  static Future<bool> areCoordinatesValid(
      double latitude, double longitude) async {
    if (latitude == 0 || longitude == 0) {
      return false;
    }
    if (latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      throw ArgumentError('Invalid coordinates');
    }

    return true;
  }

  static Future<void> shareLocationLink(
      BuildContext context, double latitude, double longitude) async {
    final String googleMapsUrl = Platform.isIOS
        ? 'https://maps.apple.com/?ll=$latitude,$longitude'
        : 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    await Share.share(googleMapsUrl);
    Navigator.pop(context);
  }

  static Future<bool> openInMapApp(double latitude, double longitude) async {
    Uri geoUri;

    if (Platform.isIOS) {
      // Try Google Maps for iOS first
      geoUri = Uri.parse('comgooglemaps://?center=$latitude,$longitude');
      if (!await canLaunchUrl(geoUri)) {
        // Fallback to Apple Maps
        geoUri = Uri.parse('maps://?ll=$latitude,$longitude');
      }
    } else {
      // Android uses geo: scheme
      geoUri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');
    }

    try {
      if (await canLaunchUrl(geoUri)) {
        await launchUrl(geoUri);
        return true;
      } else {
        // No map apps available
        return false;
      }
    } catch (e) {
      debugPrint('Error launching map: $e');
      return false;
    }
  }

  // static Future<void> shareLocationToApp(
  //     BuildContext context, double latitude, double longitude) async {
  //   // Check if coordinates are valid

  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SafeArea(
  //         child: Wrap(
  //           children: <Widget>[
  //             ListTile(
  //               leading: const Icon(Icons.map),
  //               title: const Text('Open in Google Maps'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             // ListTile(
  //             //   leading: const Icon(Icons.share_location),
  //             //   title: const Text('Share Location Link'),
  //             //   onTap: () async {
  //             //     final String googleMapsUrl = Platform.isIOS
  //             //         ? 'https://maps.apple.com/?ll=$latitude,$longitude'
  //             //         : 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  //             //     await Share.share(googleMapsUrl);
  //             //     Navigator.pop(context);
  //             //   },
  //             // ),
  //             ListTile(
  //               leading: const Icon(Icons.format_list_numbered),
  //               title: const Text('Share Coordinates'),
  //               onTap: () async {
  //                 final String coords =
  //                     'Latitude: $latitude, Longitude: $longitude';
  //                 await Share.share(coords);
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.apps),
  //               title: const Text('Open with other apps'),
  //               onTap: () async {
  //                 Uri geoUri;
  //                 if (Platform.isIOS) {
  //                   // iOS uses comgooglemaps:// scheme for Google Maps
  //                   geoUri = Uri.parse(
  //                       'comgooglemaps://?center=$latitude,$longitude');
  //                   if (!await canLaunchUrl(geoUri)) {
  //                     // Fallback to Apple Maps
  //                     geoUri = Uri.parse('maps://?ll=$latitude,$longitude');
  //                   }
  //                 } else {
  //                   // Android uses geo: scheme
  //                   geoUri = Uri.parse(
  //                       'geo:$latitude,$longitude?q=$latitude,$longitude');
  //                 }

  //                 try {
  //                   if (await canLaunchUrl(geoUri)) {
  //                     await launchUrl(geoUri);
  //                   } else {
  //                     // Fallback to a regular share if no map apps are available
  //                     final String coords =
  //                         'Latitude: $latitude, Longitude: $longitude';
  //                     await Share.share(coords);
  //                   }
  //                 } catch (e) {
  //                   // Handle any errors that might occur during launching
  //                   debugPrint('Error launching map: $e');
  //                   final String coords =
  //                       'Latitude: $latitude, Longitude: $longitude';
  //                   await Share.share(coords);
  //                 }
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  static void handleGeoUri(Uri uri, BuildContext context) {
    try {
      final coordinates = uri.path.split(',');
      if (coordinates.length == 2) {
        final latitude = double.parse(coordinates[0]);
        final longitude = double.parse(coordinates[1]);
        showMapOptions(context, latitude, longitude);
      }
    } catch (e) {
      debugPrint('Error parsing geo URI: $e');
    }
  }

  static Future<void> showMapOptions(
      BuildContext context, double latitude, double longitude) async {
    final geoUri = Uri.parse('geo:$latitude,$longitude?q=$latitude,$longitude');

    if (await canLaunchUrl(geoUri)) {
      await launchUrl(geoUri);
    } else {
      // Fallback to web URL
      final webUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }
}
