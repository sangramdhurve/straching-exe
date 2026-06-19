import 'package:flutter/material.dart';

/// The 9 anatomical sections the app is organized around ("part to part").
/// Counts are computed at runtime from the stretch library.
class BodyPart {
  final String id;
  final String name;
  final IconData icon;

  const BodyPart({required this.id, required this.name, required this.icon});

  static const List<BodyPart> all = [
    BodyPart(id: 'neck', name: 'Neck', icon: Icons.self_improvement),
    BodyPart(
        id: 'shoulders_upper_back',
        name: 'Shoulders & Upper Back',
        icon: Icons.accessibility_new),
    BodyPart(id: 'arms_wrists', name: 'Arms & Wrists', icon: Icons.back_hand),
    BodyPart(id: 'chest', name: 'Chest', icon: Icons.open_in_full),
    BodyPart(
        id: 'back',
        name: 'Mid & Lower Back',
        icon: Icons.airline_seat_recline_normal),
    BodyPart(
        id: 'hips_glutes', name: 'Hips & Glutes', icon: Icons.directions_walk),
    BodyPart(
        id: 'hamstrings',
        name: 'Hamstrings',
        icon: Icons.airline_seat_legroom_extra),
    BodyPart(
        id: 'quads_hipflexors',
        name: 'Quads & Hip Flexors',
        icon: Icons.directions_run),
    BodyPart(
        id: 'calves_ankles', name: 'Calves & Ankles', icon: Icons.hiking),
  ];

  static BodyPart? byId(String id) {
    for (final b in all) {
      if (b.id == id) return b;
    }
    return null;
  }
}
