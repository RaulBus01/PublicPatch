import '../entity/Report.dart';

// First, let's create some mock data
List<Report> getMockReports() {
  return [
    Report(
      id: 1,
      latitude: 45.86,
      longitude: 21.2,
      title: "Traffic Incident",
      description: "Major traffic due to construction work",
      imageUrls: [
        'assets/images/report.png',
        'assets/images/Login.jpg',
        'assets/images/Login.jpg',
      ],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Report(
      id: 2,
      latitude: 45.85,
      longitude: 21.22,
      title: "Road Closure",
      description: "Road closed for maintenance",
      imageUrls: [
        'assets/images/report.png',
        'assets/images/Login.jpg',
        'assets/images/Login.jpg',
      ],
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Report(
      id: 3,
      latitude: 45.87,
      longitude: 21.19,
      title: "Accident",
      description: "Minor accident, police on scene",
      imageUrls: [
        'assets/images/report.png',
        'assets/images/Login.jpg',
        'assets/images/Login.jpg',
      ],
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Report(
      id: 4,
      latitude: 45.855,
      longitude: 21.21,
      title: "Hazard",
      description: "Fallen tree blocking sidewalk",
      imageUrls: [
        'assets/images/report.png',
        'assets/images/Login.jpg',
        'assets/images/Login.jpg',
      ],
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    Report(
      id: 5,
      latitude: 45.86,
      longitude: 21.2,
      title: "Traffic Incident",
      description: "Major traffic due to construction work",
      imageUrls: [
        'assets/images/report.png',
        'assets/images/Login.jpg',
        'assets/images/Login.jpg',
      ],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Report(
      id: 6,
      latitude: 45.85,
      longitude: 26.22,
      title:
          "Road Closuremaintenancemaintenancemaintenancemaintenancemaintenancemaintenance",
      description: "Road closed for maintenance",
      imageUrls: [
        'assets/images/report.png',
        'assets/images/Login.jpg',
        'assets/images/Login.jpg',
      ],
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Report(
      id: 7,
      latitude: 43.87,
      longitude: 21.19,
      title: "Accident",
      description: "Minor accident, police on scene",
      imageUrls: [
        'assets/images/report.png',
        'assets/images/Login.jpg',
        'assets/images/Login.jpg',
      ],
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];
}
