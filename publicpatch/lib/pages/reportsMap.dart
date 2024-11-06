import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter/rendering.dart';
import 'package:ionicons/ionicons.dart';
import 'package:publicpatch/entity/Report.dart';
import 'package:publicpatch/mocks/MockReports.dart';
import 'package:publicpatch/components/ReportDetailsMap.dart';
import 'package:publicpatch/components/GalleryView.dart';

class ReportsMapPage extends StatefulWidget {
  final double? longitude, latitude;

  const ReportsMapPage({super.key, this.longitude, this.latitude});

  @override
  State<ReportsMapPage> createState() => _ReportsMapPageState();
}

class _ReportsMapPageState extends State<ReportsMapPage> {
  late final MapController controller;
  late bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final List<Report> mockReports = getMockReports();
  bool _mapIsReady = false;

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initPosition: GeoPoint(
        latitude: widget.latitude ?? 45.86,
        longitude: widget.longitude ?? 21.2,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _addMockMarkers() async {
    if (!_mapIsReady) return;

    try {
      for (final report in mockReports) {
        final marker = await controller.addMarker(
          GeoPoint(latitude: report.latitude, longitude: report.longitude),
          markerIcon: MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 48,
            ),
          ),
        );
      }

      // Set up marker click listener
    } catch (e) {
      print('Error adding markers: $e');
    }
  }

  void _showReportDetails(Report report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      builder: (BuildContext context) {
        return ReportDetailsMap(report: report);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1C2A),
        titleTextStyle: const TextStyle(fontSize: 18, color: Colors.white),
        title: const Text('Reports Map'),
      ),
      body: Stack(
        children: [
          OSMFlutter(
            controller: controller,
            onGeoPointClicked: (geoPoint) {
              final report = mockReports.firstWhere(
                (report) =>
                    report.latitude == geoPoint.latitude &&
                    report.longitude == geoPoint.longitude,
              );
              _showReportDetails(report);
            },
            onMapIsReady: (isReady) {
              if (isReady) {
                setState(() {
                  _mapIsReady = true;
                });
                _addMockMarkers();
              }
            },
            mapIsLoading: const Center(
              child: CircularProgressIndicator(),
            ),
            osmOption: OSMOption(
              zoomOption: ZoomOption(
                initZoom: 8,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 108,
                  ),
                ),
                directionArrowMarker: MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
                ),
              ),
              roadConfiguration: RoadOption(
                roadColor: Colors.yellowAccent,
              ),
              showZoomController: true,
              enableRotationByGesture: true,
            ),
          ),
          if (_isSearching)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  onTapOutside: (PointerDownEvent event) {
                    setState(() {
                      _isSearching = false;
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(
                      Ionicons.search_outline,
                      color: Colors.white,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1A1C2A),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Ionicons.close_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                        });
                      },
                    ),
                  ),
                  autofocus: true,
                ),
              ),
            ),
          ButtonLayer(),
        ],
      ),
    );
  }

  Positioned ButtonLayer() {
    return Positioned(
      top: _isSearching ? 80 : 16,
      left: 16,
      right: 16,
      bottom: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: !_isSearching
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: const Color(0xFF1A1C2A),
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size(30, 30),
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    child: const Icon(
                      Ionicons.search_outline,
                      color: Colors.white,
                      size: 22,
                    ),
                  )
                : const SizedBox(),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.transparent,
                    shape: CircleBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    backgroundColor: const Color(0xFF1A1C2A),
                    padding: const EdgeInsets.all(8),
                    minimumSize: Size(50, 50),
                  ),
                  onPressed: () async {
                    try {
                      await controller.currentLocation();
                      await controller.enableTracking(enableStopFollow: true);
                    } catch (e) {
                      // print(e);
                    }
                  },
                  child: const Icon(
                    Ionicons.locate_outline,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
