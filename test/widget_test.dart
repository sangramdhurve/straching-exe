// Unit test for the Stretch model — no plugins or assets required.

import 'package:flutter_test/flutter_test.dart';
import 'package:stretchhome/models/stretch.dart';

void main() {
  test('Stretch.fromJson parses required fields', () {
    final s = Stretch.fromJson({
      'id': 'neck_side_stretch',
      'name': 'Neck Side Stretch',
      'bodyPartId': 'neck',
      'bodyPart': 'Neck',
      'props': ['none'],
      'level': 'standard',
      'targetMuscles': ['Upper trapezius'],
      'holdSeconds': 30,
      'sides': 2,
      'durationLabel': '30 sec each side',
      'steps': ['Step one', 'Step two'],
      'breathingCue': 'Exhale slowly',
      'commonMistakes': ['Do not force it'],
      'safetyNote': 'Move gently',
      'variants': {'gentle': 'easier', 'deeper': 'harder'},
      'assetType': 'illustration',
      'assetFile': 'assets/visuals/neck_side_stretch.png',
      'tags': ['desk'],
    });

    expect(s.id, 'neck_side_stretch');
    expect(s.holdSeconds, 30);
    expect(s.sides, 2);
    expect(s.steps.length, 2);
    expect(s.usesProps, isFalse); // only "none"
  });
}
