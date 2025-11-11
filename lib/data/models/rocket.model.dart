class Rocket {
  final String name;
  final String description;
  final double height;
  final double diameter;
  final double costPerLaunch;
  final double successRatePct;
  final DateTime firstFlight;
  final String country;
  final String company;

  Rocket({
    required this.name,
    required this.description,
    required this.height,
    required this.diameter,
    required this.costPerLaunch,
    required this.successRatePct,
    required this.firstFlight,
    required this.country,
    required this.company,
  });

  static Rocket mock() => Rocket(
    name: 'Falcon 9',
    description: 'A two-stage rocket designed and manufactured by SpaceX for the reliable and safe transport of satellites and the Dragon spacecraft into orbit.',
    height: 22.25,
    diameter: 1.68,
    costPerLaunch: 50000000.0,
    successRatePct: 97.0,
    firstFlight: DateTime(2010, 6, 4),
    country: 'USA',
    company: 'SpaceX',
  );

  factory Rocket.fromJson(Map<String, dynamic> json) {
    return Rocket(
      name: json['name'],
      description: json['description'],
      height: (json['height']['meters'] as num).toDouble(),
      diameter: (json['diameter']['meters'] as num).toDouble(),
      costPerLaunch: (json['cost_per_launch'] as num).toDouble(),
      successRatePct: (json['success_rate_pct'] as num).toDouble(),
      firstFlight: DateTime.parse(json['first_flight']),
      country: json['country'],
      company: json['company'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'height': {'meters': height},
      'diameter': {'meters': diameter},
      'cost_per_launch': costPerLaunch,
      'success_rate_pct': successRatePct,
      'first_flight': firstFlight.toIso8601String(),
      'country': country,
      'company': company,
    };
  }
}
