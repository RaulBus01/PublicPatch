import 'package:flutter/material.dart';
import 'package:publicpatch/components/ImageCarousel.dart';
import 'package:publicpatch/models/Report.dart';
import 'package:publicpatch/components/GalleryView.dart';
import 'package:geocoding/geocoding.dart';
import 'package:publicpatch/utils/maps_utils.dart';

class ReportDetailsMap extends StatefulWidget {
  final Report report;
  const ReportDetailsMap({
    super.key,
    required this.report,
  });

  @override
  State<ReportDetailsMap> createState() => _ReportDetailsMapState();
}

String _formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else {
    return '${difference.inDays} days ago';
  }
}

class _ReportDetailsMapState extends State<ReportDetailsMap> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1B1D29),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF2A2D3A),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Report Details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Padding(padding: const EdgeInsets.all(8.0)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      padding: EdgeInsets.all(8),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(79, 148, 151, 172),
                        ),
                      ),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        MapUtils.shareLocationLink(
                            context,
                            widget.report.location.latitude,
                            widget.report.location.longitude,
                            widget.report.location.address,
                            widget.report.title,
                            widget.report.description);
                      },
                      icon: const Icon(
                        Icons.share_location_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(8),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(79, 148, 151, 172),
                        ),
                      ),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  ListTile(
                      minVerticalPadding: 20,
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.report.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Color(0xFF768196),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _formatDateTime(widget.report.createdAt),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      )),

                  ListTile(
                    minVerticalPadding: 20,
                    title: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFF768196),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    widget.report.location.address,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(8),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    const Color.fromARGB(79, 148, 151, 172),
                                  ),
                                ),
                                constraints: const BoxConstraints(),
                                onPressed: () async {
                                  final success = await MapUtils.openInMapApp(
                                      widget.report.location.latitude,
                                      widget.report.location.longitude);
                                  debugPrint(
                                      'Open in map app success: $success');
                                },
                                icon: const Icon(
                                  Icons.directions_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  widget.report.ReportImages.isNotEmpty
                      ? GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GalleryView(
                                imageUrls: widget.report.ReportImages,
                              ),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 200,
                              child: ImageCarousel(
                                imageUrls: widget.report.ReportImages,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(), // Empty widget when no images

                  widget.report.description.isNotEmpty
                      ? ListTile(
                          minVerticalPadding: 20,
                          title: Row(
                            children: [
                              const Icon(
                                Icons.description,
                                color: Color(0xFF768196),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  widget.report.description,
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox
                          .shrink(), // Empty widget when no description
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
