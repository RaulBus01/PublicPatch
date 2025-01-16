import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/components/BottomPanel.dart';
import 'package:publicpatch/models/LocationData.dart';
import 'package:publicpatch/models/Report.dart';
import 'package:publicpatch/pages/editreport.dart';
import 'package:publicpatch/pages/reportForm.dart';
import 'package:publicpatch/pages/reportsMap.dart';
import 'package:publicpatch/components/GalleryView.dart';
import 'package:publicpatch/service/report_Service.dart';
import 'package:publicpatch/service/user_secure.dart';
import 'package:publicpatch/utils/create_route.dart';
import 'package:publicpatch/utils/maps_utils.dart';
import 'package:publicpatch/utils/time_utils.dart';

import '../components/ImageCarousel.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  List<Report> reports = [];
  bool showUserReports = false;
  void _handleDelete(int id) {
    setState(() {
      reports.removeWhere((element) => element.id == id);
    });
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports(showUserReports);
  }

  var userId = 0;
  Future<void> _loadReports(showUserReports) async {
    try {
      final reportService = ReportService();
      userId = await UserSecureStorage.getUserId();
      final fetchedReports = showUserReports
          ? await reportService.getUserReports(userId)
          : await reportService.getReports();

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
        surfaceTintColor: const Color.fromARGB(0, 255, 255, 255),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButtons(
              constraints: const BoxConstraints(
                minWidth: 50, // Adjust as needed
                minHeight: 30,
              ),
              color: Color(0xFF768196), // Unselected text/icon color
              selectedColor: Colors.white, // Selected text/icon color
              fillColor: Colors.white.withOpacity(0.1),
              isSelected: [!showUserReports, showUserReports],
              onPressed: (index) {
                setState(() {
                  showUserReports = index == 1;
                  _loadReports(showUserReports);
                  isLoading = true;
                });
              },
              borderRadius: BorderRadius.circular(8),
              children: const [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Text(
                      'All Reports',
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Text('Your Reports')),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0XFF0D0E15),
        titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
      ),
      backgroundColor: const Color(0XFF0D0E15),
      body: Container(
        alignment: Alignment.center,
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
            if (reports.isEmpty && !isLoading)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You have no reports',
                        style: TextStyle(color: Colors.white),
                      ),
                      Padding(padding: const EdgeInsets.all(10)),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CreateRoute.createRoute(
                                    const ReportFormPage()));
                          },
                          icon: Icon(Ionicons.add_circle_outline,
                              size: 40, color: Colors.white))
                    ],
                  ),
                ),
              ),
            for (var report in reports)
              ReportCard(
                id: report.id,
                title: report.title,
                userId: report.userId,
                loggedUserId: userId,
                location: report.location,
                description: report.description,
                imageUrls: report.ReportImages,
                timeAgo: report.createdAt.toLocal(),
                status: report.status,
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
  final int userId;
  final int loggedUserId;
  final LocationData location;
  final String description;
  final List<String> imageUrls;
  final DateTime timeAgo;
  final int status;
  final Function(int) onDelete;

  const ReportCard({
    required this.id,
    required this.title,
    required this.location,
    required this.userId,
    required this.loggedUserId,
    required this.description,
    required this.imageUrls,
    required this.timeAgo,
    required this.onDelete,
    required this.status,
    super.key,
  });

  void _showGallery(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GalleryView(imageUrls: imageUrls),
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'In Progress';
      case 2:
        return 'Resolved';
      case 3:
        return 'Rejected';
      default:
        return 'Unknown';
    }
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
                        Navigator.pushReplacement(
                            context,
                            CreateRoute.createRoute(EditReportPage(
                              reportId: id,
                              title: title,
                              description: description,
                              imageUrls: imageUrls,
                              location: location,
                            )));
                        print('Edit Report');
                      },
                    ),
                    Divider(color: Colors.white54),
                    if (status != 3 && status != 2)
                      Column(
                        children: [
                          ListTile(
                              leading: const Icon(Icons.update,
                                  color: Colors.white54),
                              title: const Text('Update Status',
                                  style: TextStyle(color: Colors.white)),
                              onTap: () async {
                                Navigator.pop(context);
                                final int? newStatus = await showDialog<int>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0XFF1B1D29),
                                      title: const Text('Update Status',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (status == 0) ...[
                                            ListTile(
                                              title: const Text('In Progress',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onTap: () =>
                                                  Navigator.pop(context, 1),
                                            ),
                                            Divider(color: Colors.white54),
                                            ListTile(
                                              title: const Text('Resolved',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onTap: () =>
                                                  Navigator.pop(context, 2),
                                            ),
                                          ] else if (status == 1) ...[
                                            ListTile(
                                              title: const Text('Resolved',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                              onTap: () =>
                                                  Navigator.pop(context, 2),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                );

                                if (newStatus != null) {
                                  try {
                                    await ReportService()
                                        .updateReportStatus(id, newStatus);

                                    if (context.mounted) {
                                      Fluttertoast.showToast(
                                        msg:
                                            'Report status updated successfully',
                                        backgroundColor: Colors.green,
                                        gravity: ToastGravity.TOP,
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Fluttertoast.showToast(
                                        msg: 'Error updating report status',
                                        backgroundColor: Colors.red,
                                        gravity: ToastGravity.TOP,
                                      );
                                    }
                                  }
                                }
                              }),
                          Divider(color: Colors.white54),
                        ],
                      ),
                    userId == loggedUserId
                        ? ListTile(
                            leading:
                                const Icon(Icons.delete, color: Colors.white54),
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
                                        onPressed: () =>
                                            Navigator.pop(context, true),
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
                                    Fluttertoast.showToast(
                                      msg: 'Report deleted successfully',
                                      backgroundColor: Colors.green,
                                      gravity: ToastGravity.TOP,
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    Fluttertoast.showToast(
                                      msg: 'Error deleting report',
                                      backgroundColor: Colors.red,
                                      gravity: ToastGravity.TOP,
                                    );
                                  }
                                }
                              }
                            },
                          )
                        : const SizedBox.shrink(),
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
            imageUrls.isNotEmpty
                ? Center(
                    child: GestureDetector(
                      onTap: () => _showGallery(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.width * 0.7,
                          child: ImageCarousel(imageUrls: imageUrls),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: SelectableText(
                'Status: ${_getStatusText(status)}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: SelectableText(
                TimeUtils.formatDateTime(timeAgo),
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
