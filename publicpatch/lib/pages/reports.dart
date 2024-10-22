import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/components/BottomPanel.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SelectableText('Your Reports'),
        backgroundColor: const Color(0XFF0D0E15),
        titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      backgroundColor: const Color(0XFF1B1D29),
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
              imageUrl: 'assets/images/report.png',
              timeAgo: '30 min ago',
            ),
            ReportCard(
              location: 'Ferentari, Romania',
              description: 'Ai parcat ca un bou!',
              imageUrl: 'assets/images/report.png',
              timeAgo: '30 min ago',
            ),
            ReportCard(
              location: 'Ferentari, Romania',
              description: 'Ai parcat ca un bou!',
              imageUrl: 'assets/images/report.png',
              timeAgo: '30 min ago',
            ),
            ReportCard(
              location: 'Ferentari, Romania',
              description: 'Ai parcat ca un bou!',
              imageUrl: 'assets/images/report.png',
              timeAgo: '30 min ago',
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
  final String imageUrl;
  final String timeAgo;

  const ReportCard({
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.timeAgo,
    super.key,
  });

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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 150,
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
