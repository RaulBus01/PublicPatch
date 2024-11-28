import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/components/BottomPanel.dart';
import 'package:publicpatch/models/LocationData.dart';
import 'package:publicpatch/models/Report.dart';
import 'package:publicpatch/pages/reportsMap.dart';
import 'package:publicpatch/components/GalleryView.dart';
import 'package:publicpatch/service/report_Service.dart';
import 'package:publicpatch/service/user_secure.dart';
import 'package:publicpatch/utils/maps_utils.dart';

import '../components/ImageCarousel.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Report> reports = [];

  void _handleDelete(int id) {
    setState(() {
      reports.removeWhere((element) => element.id == id);
    });
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    try {
      final reportService = ReportService();
      final userId = await UserSecureStorage.getUserId();
      final fetchedReports = await reportService.getReports(userId);

      if (mounted) {
        // Check if widget is still in tree
        setState(() {
          reports = fetchedReports;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

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
            for (var report in reports)
              ReportCard(
                id: report.id,
                title: report.title,
                location: report.location,
                description: report.description,
                imageUrls: report.imageUrls,
                timeAgo: report.createdAt.toString(),
                onDelete: _handleDelete,
              ),
          ],
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final int id;
  final String title;
  final LocationData location;
  final String description;
  final List<String> imageUrls;
  final String timeAgo;
  final Function(int) onDelete;

  const ReportCard({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.imageUrls,
    required this.timeAgo,
    required this.onDelete,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: SelectableText(
                        location.address,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
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
                              latitude: location.latitude,
                              longitude: location.longitude,
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
                        MapUtils.shareLocationLink(
                          context,
                          location.latitude,
                          location.longitude,
                          location.toString(),
                          title,
                          description,
                        );
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
                      onTap: () async {
                        Navigator.pop(context);
                        final bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0XFF1B1D29),
                              title: const Text('Confirm Deletion',
                                  style: TextStyle(color: Colors.white)),
                              content: const Text(
                                  style: TextStyle(color: Colors.white),
                                  'Are you sure you want to delete this report?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('DELETE'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          try {
                            await ReportService().deleteReport(id);

                            if (context.mounted) {
                              onDelete(id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Report deleted successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to delete report: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ],
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
