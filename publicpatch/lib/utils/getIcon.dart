import 'package:flutter/material.dart';

IconData getIconFromString(String iconName) {
  print(iconName);
  // Material Icons mapping
  final Map<String, IconData> iconMap = {
    'TrafficIcon': Icons.traffic,
    'LocalParkingIcon': Icons.local_parking,
    // Add more mappings as needed
  };

  return iconMap[iconName] ?? Icons.help_outline;
}
