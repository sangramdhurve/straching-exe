import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/body_part.dart';
import '../models/routine.dart';
import '../models/stretch.dart';

/// Loads and serves all stretch + routine content from bundled JSON.
/// No network/backend required — everything ships inside the app.
class ContentRepository {
  ContentRepository._();
  static final ContentRepository instance = ContentRepository._();

  final List<Stretch> _stretches = [];
  final List<Routine> _routines = [];
  final Map<String, Stretch> _byId = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;
  List<Stretch> get stretches => List.unmodifiable(_stretches);
  List<Routine> get routines => List.unmodifiable(_routines);

  Future<void> load() async {
    if (_loaded) return;
    final stretchRaw = await rootBundle.loadString('assets/data/stretches.json');
    final routineRaw = await rootBundle.loadString('assets/data/routines.json');

    final sMap = json.decode(stretchRaw) as Map<String, dynamic>;
    final rMap = json.decode(routineRaw) as Map<String, dynamic>;

    _stretches
      ..clear()
      ..addAll((sMap['stretches'] as List)
          .map((e) => Stretch.fromJson(e as Map<String, dynamic>)));
    _routines
      ..clear()
      ..addAll((rMap['routines'] as List)
          .map((e) => Routine.fromJson(e as Map<String, dynamic>)));

    _byId
      ..clear()
      ..addEntries(_stretches.map((s) => MapEntry(s.id, s)));

    _loaded = true;
  }

  Stretch? byId(String id) => _byId[id];

  List<Stretch> byBodyPart(String bodyPartId) =>
      _stretches.where((s) => s.bodyPartId == bodyPartId).toList();

  int countFor(String bodyPartId) =>
      _stretches.where((s) => s.bodyPartId == bodyPartId).length;

  /// Body parts that actually have at least one stretch.
  List<BodyPart> get bodyParts =>
      BodyPart.all.where((b) => countFor(b.id) > 0).toList();

  List<Stretch> stretchesForRoutine(Routine r) =>
      r.stretchIds.map((id) => _byId[id]).whereType<Stretch>().toList();

  /// Distinct props (excluding "none") used within a body part — drives filters.
  List<String> propsFor(String bodyPartId) {
    final set = <String>{};
    for (final s in byBodyPart(bodyPartId)) {
      set.addAll(s.props.where((p) => p != 'none'));
    }
    return set.toList()..sort();
  }

  List<Stretch> search(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return _stretches
        .where((s) =>
            s.name.toLowerCase().contains(query) ||
            s.bodyPart.toLowerCase().contains(query) ||
            s.tags.any((t) => t.toLowerCase().contains(query)))
        .toList();
  }

  Routine? routineById(String id) {
    for (final r in _routines) {
      if (r.id == id) return r;
    }
    return null;
  }

  /// Simple deterministic "today's pick" so it feels fresh but stable per day.
  Routine? get dailySuggestion {
    if (_routines.isEmpty) return null;
    return _routines[DateTime.now().day % _routines.length];
  }
}
