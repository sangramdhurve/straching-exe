import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/content_repository.dart';
import '../../models/body_part.dart';
import '../../widgets/banner_ad_slot.dart';
import '../../widgets/responsive.dart';
import '../../widgets/stretch_tile.dart';
import '../stretch/stretch_detail_screen.dart';

/// Stretch list for one body part, with prop + level filter chips.
class BodyPartScreen extends StatefulWidget {
  final BodyPart bodyPart;
  const BodyPartScreen({super.key, required this.bodyPart});

  @override
  State<BodyPartScreen> createState() => _BodyPartScreenState();
}

class _BodyPartScreenState extends State<BodyPartScreen> {
  String? _propFilter;
  String? _levelFilter;

  static const _levels = ['gentle', 'standard', 'deeper'];

  @override
  Widget build(BuildContext context) {
    final repo = ContentRepository.instance;
    final all = repo.byBodyPart(widget.bodyPart.id);
    final props = repo.propsFor(widget.bodyPart.id);
    final list = all
        .where((s) =>
            (_propFilter == null || s.props.contains(_propFilter)) &&
            (_levelFilter == null || s.level == _levelFilter))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.bodyPart.name)),
      body: MaxWidth(
        child: Column(
          children: [
          if (props.isNotEmpty) ...[
            _filterLabel(context, 'Props'),
            _chipRow([
              _chip('All', _propFilter == null,
                  () => setState(() => _propFilter = null)),
              for (final p in props)
                _chip(_cap(p), _propFilter == p,
                    () => setState(() => _propFilter = p)),
            ]),
          ],
          _filterLabel(context, 'Level'),
          _chipRow([
            _chip('All', _levelFilter == null,
                () => setState(() => _levelFilter = null)),
            for (final l in _levels)
              _chip(_cap(l), _levelFilter == l,
                  () => setState(() => _levelFilter = l)),
          ]),
          Expanded(
            child: list.isEmpty
                ? _empty(context)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.md,
                        AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
                    itemCount: list.length,
                    itemBuilder: (context, i) => StretchTile(
                      stretch: list[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                StretchDetailScreen(stretch: list[i])),
                      ),
                    ),
                  ),
          ),
          const BannerAdSlot(),
        ],
        ),
      ),
    );
  }

  String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Widget _filterLabel(BuildContext c, String t) => Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.sm, AppSpacing.md, 2),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(t,
              style: Theme.of(c).textTheme.labelMedium?.copyWith(
                  color: Theme.of(c).colorScheme.onSurfaceVariant)),
        ),
      );

  Widget _chipRow(List<Widget> chips) => SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          children: chips,
        ),
      );

  Widget _chip(String label, bool selected, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onTap(),
        ),
      );

  Widget _empty(BuildContext c) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'No stretches match these filters.',
                textAlign: TextAlign.center,
                style: Theme.of(c).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(c).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => setState(() {
                  _propFilter = null;
                  _levelFilter = null;
                }),
                child: const Text('Clear filters'),
              ),
            ],
          ),
        ),
      );
}
