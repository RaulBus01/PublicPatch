import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/components/BottomPanel.dart';
import 'package:publicpatch/pages/reportsMap.dart';
import 'package:publicpatch/components/GalleryView.dart';

import '../components/ImageCarousel.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: SelectableText('Your Reports'),
        backgroundColor: const Color(0XFF0D0E15),
        titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      backgroundColor: const Color(0XFF0D0E15),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(134, 54, 60, 73),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            ReportCard(
              location: 'Timisoara, Romania',
              description:
                  'Spent all day in this cozy place with my laptop. Undoubtedly the best place for work.',
              imageUrls: [
                'assets/images/report.png',
                'assets/images/Login.jpg',
                'assets/images/Login.jpg',
              ],
              timeAgo: '30 min ago',
              latitude: 21.7489,
              longitude: 40.2087,
            ),
            ReportCard(
              location: 'Ferentari, Romania',
              description: 'Ai parcat ca un bou!',
              imageUrls: ['assets/images/report.png'],
              timeAgo: '30 min ago',
              latitude: 44.4167,
              longitude: 26.1000,
            ),
            ReportCard(
              location: 'Ferentari, Romania',
              description: 'Ai parcat ca un bou!',
              imageUrls: ['assets/images/report.png'],
              timeAgo: '30 min ago',
              latitude: 44.4167,
              longitude: 21.1000,
            ),
            ReportCard(
              location: 'Ferentari, Romania',
              description: 'Ai parcat ca un bou!',
              imageUrls: ['assets/images/report.png'],
              timeAgo: '30 min ago',
              latitude: 44.4167,
              longitude: 26.1000,
            ),
          ],
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String location;
  final String description;
  final List<String> imageUrls;
  final String timeAgo;
  final double latitude;
  final double longitude;

  const ReportCard({
    required this.location,
    required this.description,
    required this.imageUrls,
    required this.timeAgo,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  void _showGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GalleryView(imageUrls: imageUrls),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0XFF1B1D29),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Ionicons.location_outline,
                        color: Colors.white54, size: 24),
                    const SizedBox(width: 4),
                    SelectableText(
                      location,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
                BottomPanel(
                  icon: const Icon(Ionicons.ellipsis_horizontal,
                      color: Colors.white54, size: 24),
                  menuOptions: [
                    ListTile(
                      leading: const Icon(Icons.map, color: Colors.white54),
                      title: const Text('Show on Map',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReportsMapPage(
                              latitude: latitude,
                              longitude: longitude,
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(color: Colors.white54),
                    ListTile(
                      leading: const Icon(Icons.share, color: Colors.white54),
                      title: const Text('Share Report',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pop(context);
                        print('Share Report');
                      },
                    ),
                    Divider(color: Colors.white54),
                    ListTile(
                      leading: const Icon(Icons.edit, color: Colors.white54),
                      title: const Text('Edit Report',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pop(context);
                        print('Edit Report');
                      },
                    ),
                    Divider(color: Colors.white54),
                    ListTile(
                      leading: const Icon(Icons.delete, color: Colors.white54),
                      title: const Text('Delete Report',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pop(context);
                        print('Delete Report');
                      },
                    ),
                  ], // Menu options passed to the bottom panel
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(
              description,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showGallery(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.width * 0.5,
                  child: ImageCarousel(imageUrls: imageUrls),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: SelectableText(
                timeAgo,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
