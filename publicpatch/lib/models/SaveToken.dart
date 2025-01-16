class SaveToken {
  final String FCMKey;
  final int UserId;
  final String DeviceType;

  SaveToken({
    required this.FCMKey,
    required this.UserId,
    required this.DeviceType,
  });

  Map<String, dynamic> toMap() {
    return {
      'FCMKey': FCMKey,
      'UserId': UserId,
      'DeviceType': DeviceType,
    };
  }

  factory SaveToken.fromMap(Map<String, dynamic> map) {
    return SaveToken(
      FCMKey: map['FCMKey'],
      UserId: map['UserId'],
      DeviceType: map['DeviceType'],
    );
  }
}
