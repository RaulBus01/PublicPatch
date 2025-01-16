class GetTokenModel {
  final int id;
  final String FCMKey;
  final String DeviceType;
  final int UserId;
  final bool isActive;

  GetTokenModel({
    required this.id,
    required this.FCMKey,
    required this.DeviceType,
    required this.UserId,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'FCMKey': FCMKey,
      'DeviceType': DeviceType,
      'UserId': UserId,
      'isActive': isActive,
    };
  }

  factory GetTokenModel.fromMap(Map<String, dynamic> map) {
    return GetTokenModel(
      id: map['id'],
      FCMKey: map['fcmKey'],
      DeviceType: map['deviceType'],
      UserId: map['userId'],
      isActive: map['isActive'],
    );
  }
}
