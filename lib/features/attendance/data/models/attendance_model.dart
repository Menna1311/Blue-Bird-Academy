class AttendanceModel {
  final String playerId;
  final String playerName;
  final String status;

  AttendanceModel({
    required this.playerId,
    required this.playerName,
    required this.status,
  });

  Map<String, dynamic> toMap() => {
        'playerId': playerId,
        'playerName': playerName,
        'status': status,
      };

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      playerId: map['playerId'] ?? '',
      playerName: map['playerName'] ?? '',
      status: map['status'] ?? 'غائب',
    );
  }
}
