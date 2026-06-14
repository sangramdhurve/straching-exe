/// A single stretching exercise, loaded from assets/data/stretches.json.
class Stretch {
  final String id;
  final String name;
  final String bodyPartId;
  final String bodyPart;
  final List<String> props;
  final String level; // gentle | standard | deeper (default level)
  final List<String> targetMuscles;
  final int holdSeconds;
  final int sides; // 1 or 2
  final String durationLabel;
  final List<String> steps;
  final String breathingCue;
  final List<String> commonMistakes;
  final String safetyNote;
  final Map<String, String> variants; // keys: gentle, deeper
  final String assetType; // illustration | video | lottie
  final String assetFile;
  final List<String> tags;

  const Stretch({
    required this.id,
    required this.name,
    required this.bodyPartId,
    required this.bodyPart,
    required this.props,
    required this.level,
    required this.targetMuscles,
    required this.holdSeconds,
    required this.sides,
    required this.durationLabel,
    required this.steps,
    required this.breathingCue,
    required this.commonMistakes,
    required this.safetyNote,
    required this.variants,
    required this.assetType,
    required this.assetFile,
    required this.tags,
  });

  factory Stretch.fromJson(Map<String, dynamic> j) => Stretch(
        id: j['id'] as String,
        name: j['name'] as String,
        bodyPartId: j['bodyPartId'] as String,
        bodyPart: j['bodyPart'] as String,
        props: _strList(j['props']),
        level: (j['level'] ?? 'standard').toString(),
        targetMuscles: _strList(j['targetMuscles']),
        holdSeconds: (j['holdSeconds'] ?? 30) as int,
        sides: (j['sides'] ?? 1) as int,
        durationLabel: (j['durationLabel'] ?? '').toString(),
        steps: _strList(j['steps']),
        breathingCue: (j['breathingCue'] ?? '').toString(),
        commonMistakes: _strList(j['commonMistakes']),
        safetyNote: (j['safetyNote'] ?? '').toString(),
        variants: (j['variants'] as Map?)
                ?.map((k, v) => MapEntry(k.toString(), v.toString())) ??
            const {},
        assetType: (j['assetType'] ?? 'illustration').toString(),
        assetFile: (j['assetFile'] ?? '').toString(),
        tags: _strList(j['tags']),
      );

  static List<String> _strList(dynamic v) =>
      (v as List?)?.map((e) => e.toString()).toList() ?? const [];

  /// True if this stretch needs a real prop (chair/wall/etc.), not just "none".
  bool get usesProps =>
      props.isNotEmpty && !(props.length == 1 && props.first == 'none');

  /// Total active time estimate, used for routine duration math.
  int get estimatedSeconds => holdSeconds * sides;
}
