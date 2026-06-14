/// A guided sequence of stretches, loaded from assets/data/routines.json.
class Routine {
  final String id;
  final String name;
  final String description;
  final int minutes;
  final String level; // gentle | all | deeper
  final List<String> audience;
  final List<String> tags;
  final List<String> stretchIds;

  const Routine({
    required this.id,
    required this.name,
    required this.description,
    required this.minutes,
    required this.level,
    required this.audience,
    required this.tags,
    required this.stretchIds,
  });

  factory Routine.fromJson(Map<String, dynamic> j) => Routine(
        id: j['id'] as String,
        name: j['name'] as String,
        description: (j['description'] ?? '').toString(),
        minutes: (j['minutes'] ?? 5) as int,
        level: (j['level'] ?? 'all').toString(),
        audience: _strList(j['audience']),
        tags: _strList(j['tags']),
        stretchIds: _strList(j['stretchIds']),
      );

  static List<String> _strList(dynamic v) =>
      (v as List?)?.map((e) => e.toString()).toList() ?? const [];
}
