class HealthMetrics {
  final int steps;
  final int heartRate;
  final DateTime lastUpdated;

  HealthMetrics({
    required this.steps,
    required this.heartRate,
    required this.lastUpdated,
  });

  factory HealthMetrics.fromJson(Map<String, dynamic> json) {
    return HealthMetrics(
      steps: json['steps'],
      heartRate: json['heartRate'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}