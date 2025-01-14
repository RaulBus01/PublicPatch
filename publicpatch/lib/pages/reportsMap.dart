import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:publicpatch/models/LocationData.dart';

import 'package:publicpatch/models/Report.dart';
import 'package:publicpatch/components/ReportDetailsMap.dart';
import 'package:publicpatch/service/report_Service.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportsMapPage extends StatefulWidget {
  final double? longitude, latitude;

  const ReportsMapPage({super.key, this.longitude, this.latitude});

  @override
  State<ReportsMapPage> createState() => _ReportsMapPageState();
}

class _ReportsMapPageState extends State<ReportsMapPage> {
  static const int _minFetchInterval = 5; // seconds
  static const double _minFetchDistance = 100; // meters

  final loc.Location _locationService = loc.Location();

  final Map<MarkerId, Marker> _markerMap = {};
  final ReportService _reportService = ReportService();

  late GoogleMapController _mapController;
  late ClusterManager _clusterManager;

  bool _isLoading = false;
  bool _locationPermissionGranted = false;
  DateTime? _lastRequestTime;

  LatLng? _lastFetchedCenter;
  double? _lastFetchedRadius;

  double _currentZoom = 10.0;

  Timer? _debounceTimer;
  bool _isDisposed = false;

  double _getRadiusForZoom(double zoom) {
    const double minRadius = 0.01;
    const double maxRadius = 20;

    final radius = maxRadius * pow(0.55, (zoom - 1) / 2);

    return double.parse(
      radius.clamp(minRadius, maxRadius).toStringAsFixed(4),
    );
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (!mounted) return;
    if (status.isGranted) {
      await _locationService.requestService();

      setState(() => _locationPermissionGranted = status.isGranted);
    }

    if (!mounted) return;
    setState(() => _locationPermissionGranted = status.isGranted);
  }

  void _showReportDetails(Report report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      builder: (context) => ReportDetailsMap(report: report),
    );
  }

  bool _shouldFetchData(LatLng newCenter) {
    if (_isLoading) return false;

    final now = DateTime.now();
    if (_lastRequestTime != null &&
        now.difference(_lastRequestTime!) <
            Duration(seconds: _minFetchInterval)) {
      return false;
    }

    if (_lastFetchedCenter != null) {
      final distance = Geolocator.distanceBetween(
        _lastFetchedCenter!.latitude,
        _lastFetchedCenter!.longitude,
        newCenter.latitude,
        newCenter.longitude,
      );
      if (distance < _minFetchDistance) return false;
    }

    return true;
  }

  Future<void> _fetchAndUpdateMarkers(LatLng center, double radius) async {
    if (!mounted || _isDisposed) return;

    setState(() => _isLoading = true);
    _lastRequestTime = DateTime.now();

    try {
      final reports = await _reportService.getReportsByZone(
        LocationData(
            latitude: center.latitude,
            longitude: center.longitude,
            address: '',
            radius: radius),
      );

      debugPrint('Fetched ${reports.length} reports');

      if (!mounted || _isDisposed) return;

      _updateMarkers(reports);
      _lastFetchedCenter = center;
      _lastFetchedRadius = radius;
    } catch (e) {
      debugPrint('Error fetching reports: $e');
      if (mounted) {
        setState(() => _markerMap.clear());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _updateMarkers(List<Report> reports) {
    if (!mounted) return;

    final updatedMarkers = {
      for (final report in reports)
        MarkerId(report.id.toString()): _createMarker(report)
    };

    setState(() => _markerMap
      ..clear()
      ..addAll(updatedMarkers));
  }

  Marker _createMarker(Report report) => Marker(
        markerId: MarkerId(report.id.toString()),
        position: LatLng(report.location.latitude, report.location.longitude),
        infoWindow: InfoWindow(
          title: report.title,
          snippet: report.description,
          onTap: () => _showReportDetails(report),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

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
          GoogleMap(
              mapType: MapType.normal,
              markers: Set<Marker>.from(_markerMap.values),
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(widget.latitude ?? 45.76, widget.longitude ?? 21.0),
                zoom: _currentZoom,
              ),
              myLocationEnabled: _locationPermissionGranted,
              onMapCreated: _onMapCreated,
              onCameraIdle: _onCameraIdle,
              minMaxZoomPreference:
                  MinMaxZoomPreference(5, 20), // Set min/max zoom
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: true),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _initializeMapData();
  }

  Future<void> _initializeMapData() async {
    final initialCenter = LatLng(
      widget.latitude ?? 45.76,
      widget.longitude ?? 21.0,
    );
    await _fetchAndUpdateMarkers(initialCenter, 100);
  }

  Future<void> _onCameraIdle() async {
    if (_isDisposed) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (!mounted || _isDisposed) return;

      try {
        final bounds = await _mapController.getVisibleRegion();
        final center = LatLng(
          double.parse(
              ((bounds.northeast.latitude + bounds.southwest.latitude) / 2)
                  .toStringAsFixed(2)),
          double.parse(
              ((bounds.northeast.longitude + bounds.southwest.longitude) / 2)
                  .toStringAsFixed(2)),
        );

        final zoom = await _mapController.getZoomLevel();
        if (mounted && !_isDisposed) {
          setState(() {
            _currentZoom = zoom;
          });
        }

        if (_shouldFetchData(center)) {
          await _fetchAndUpdateMarkers(center, _getRadiusForZoom(_currentZoom));
        }
      } catch (e) {
        debugPrint('Error updating camera: $e');
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }
}
