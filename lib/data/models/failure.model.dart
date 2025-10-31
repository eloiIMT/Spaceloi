class Failure {
  const Failure({
    required this.time,
    this.altitude,
    required this.reason,
  });
  final int time;
  final int? altitude;
  final String reason;

  static Failure mock() => Failure(
        time: 120,
        altitude: 300,
        reason: 'Engine failure',
  );

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(
      time: json['time'],
      altitude: json['altitude'],
      reason: json['reason'],
    );
  }
}