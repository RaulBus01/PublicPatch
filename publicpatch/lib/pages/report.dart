import 'package:flutter/material.dart';
import 'package:publicpatch/models/Report.dart';
import 'package:publicpatch/components/ImageCarousel.dart';
import 'package:publicpatch/components/GalleryView.dart';
import 'package:publicpatch/service/report_Service.dart';
import 'package:publicpatch/utils/maps_utils.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/utils/time_utils.dart';

class ReportPage extends StatefulWidget {
  final int reportId;
  const ReportPage({super.key, required this.reportId});
  static const route = '/report';
  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Report? reportData;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    try {
      final data = await ReportService().getReport(widget.reportId);
      if (mounted) {
        setState(() {
          reportData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0XFF0D0E15),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: Color(0XFF0D0E15),
        body: Center(
          child: Text(
            'Error: $error',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    if (reportData == null) {
      return const Scaffold(
        backgroundColor: Color(0XFF0D0E15),
        body: Center(
          child: Text(
            'Report not found',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Report Details',
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white)),
          ],
        ),
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
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            reportData?.title != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Report Title",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(reportData!.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          )),
                    ],
                  )
                : const SizedBox.shrink(),

            // Images Section
            reportData?.ReportImages != null &&
                    reportData!.ReportImages.isNotEmpty
                ? GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => GalleryView(
                                imageUrls: reportData!.ReportImages))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child:
                            ImageCarousel(imageUrls: reportData!.ReportImages),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 40),

            // Location Section
            Row(
              children: [
                const Icon(Ionicons.location_outline,
                    color: Colors.white54, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reportData!.location.address,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () => MapUtils.openInMapApp(
                      reportData!.location.latitude,
                      reportData!.location.longitude),
                  icon: const Icon(Icons.directions_outlined,
                      color: Colors.white54),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Description Section

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  reportData!.description,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),

            // Status & Time Section
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${_getStatusText(reportData!.status)}',
                  style: const TextStyle(color: Colors.white54),
                ),
                Text(
                  TimeUtils.formatDateTime(reportData!.createdAt),
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ],
        ),
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
}
