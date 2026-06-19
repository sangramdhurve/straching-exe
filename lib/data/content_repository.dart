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
  Routine? get dailySuggestion => dailySuggestionFor(null);

  /// "Today's pick", optionally biased toward routines the user can actually do
  /// with the props they have at home. Deterministic per day so it stays stable.
  ///
  /// Pass null (or an empty/unconfigured set) to suggest from all routines.
  /// "none" (floor, no props) is always treated as available, and if no routine
  /// is fully doable with the given props we fall back to all routines — so the
  /// home card never disappears.
  Routine? dailySuggestionFor(Set<String>? availableProps) {
    if (_routines.isEmpty) return null;
    var pool = _routines;
    if (availableProps != null) {
      final have = {...availableProps, 'none'};
      final doable = _routines
          .where((r) => _propsForRoutine(r).every(have.contains))
          .toList();
      if (doable.isNotEmpty) {
        pool = doable;
      } else {
        // None are fully doable with the user's props — pick the routine(s)
        // needing the fewest missing props, so the suggestion stays as
        // achievable as possible (never an empty/irrelevant card).
        int missing(Routine r) =>
            _propsForRoutine(r).where((p) => !have.contains(p)).length;
        final fewest =
            _routines.map(missing).reduce((a, b) => a < b ? a : b);
        pool = _routines.where((r) => missing(r) == fewest).toList();
      }
    }
    return pool[DateTime.now().day % pool.length];
  }

  /// Every distinct prop a routine needs across its stretches (excluding "none").
  Set<String> _propsForRoutine(Routine r) {
    final set = <String>{};
    for (final s in stretchesForRoutine(r)) {
      set.addAll(s.props.where((p) => p != 'none'));
    }
    return set;
  }
}
