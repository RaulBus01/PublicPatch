class LocationData {
  final double latitude;
  final double longitude;
  final String address;
  final double? radius;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.radius,
  });

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      address: map['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}
