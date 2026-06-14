import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/content_repository.dart';
import '../../models/body_part.dart';
import '../../widgets/stretch_tile.dart';
import '../stretch/stretch_detail_screen.dart';

/// Stretch list for one body part, with prop filter chips.
class BodyPartScreen extends StatefulWidget {
  final BodyPart bodyPart;
  const BodyPartScreen({super.key, required this.bodyPart});

  @override
  State<BodyPartScreen> createState() => _BodyPartScreenState();
}

class _BodyPartScreenState extends State<BodyPartScreen> {
  String? _propFilter;

  @override
  Widget build(BuildContext context) {
    final repo = ContentRepository.instance;
    final all = repo.byBodyPart(widget.bodyPart.id);
    final props = repo.propsFor(widget.bodyPart.id);
    final list = _propFilter == null
        ? all
        : all.where((s) => s.props.contains(_propFilter)).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.bodyPart.name)),
      body: Column(
        children: [
          if (props.isNotEmpty)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                children: [
                  _chip('All', _propFilter == null,
                      () => setState(() => _propFilter = null)),
                  for (final p in props)
                    _chip(p[0].toUpperCase() + p.substring(1),
                        _propFilter == p, () => setState(() => _propFilter = p)),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
              itemCount: list.length,
              itemBuilder: (context, i) => StretchTile(
                stretch: list[i],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => StretchDetailScreen(stretch: list[i])),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
        ),
      );
}
