class Location {
  final int latitude;
  final int longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
