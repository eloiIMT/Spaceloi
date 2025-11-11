
import 'failure.model.dart';

class Launch {
  const Launch({
    required this.name,
    required this.details,
    required this.date,
    this.failure,
    required this.patchUrl,
    required this.articleUrl,
    required this.imagesUrl,
    required this.id
  });

  final String name;
  final String details;
  final DateTime date;
  final Failure? failure;
  final String patchUrl;
  final String articleUrl;
  final List<String> imagesUrl;
  final String id;

  static Launch mock() => Launch(
        name: 'Falcon 9',
        details:
            'This mission will launch the tenth batch of approximately 60 satellites for Starlink\'s fourth shell, which will operate in a slightly lower orbit than prior shells. This will improve performance for users in the northern United States and Canada. The booster for this mission previously supported Crew-6, CRS-24, and Starlink missions.',
        date: DateTime.utc(2023, 5, 3, 14, 13),
        failure: Failure.mock(),
        patchUrl:
            'https://images2.imgbox.com/5b/02/QcxHUb5V_o.png',
        articleUrl:
            'https://www.space.com/2196-spacex-inaugural-falcon-1-rocket-lost-launch.html',
        imagesUrl: [
          'https://farm9.staticflickr.com/8571/16699496805_bf39747618_o.jpg',
          "https://farm9.staticflickr.com/8612/16848173281_035bdc6009_o.jpg"
        ],
        id: '5e9d0d95eda69955f709d1eb',
  );

  factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      name: json['name'],
      details: json['details'] ?? 'No details available.',
      date: DateTime.parse(json['date_utc']),
      failure: json['failures'] != null && (json['failures'] as List).isNotEmpty
          ? Failure.fromJson(json['failures'][0])
          : null,
      patchUrl: json['links']['patch']['large'] ?? '',
      articleUrl: json['links']['article'] ?? '',
      imagesUrl: (json['links']['flickr']['original'] as List)
          .map((img) => img as String)
          .toList(),
      id: json['rocket'],
    );
  }

  get success => null;
}

