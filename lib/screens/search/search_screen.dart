import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/content_repository.dart';
import '../../models/stretch.dart';
import '../../widgets/stretch_tile.dart';
import '../stretch/stretch_detail_screen.dart';

/// Search across all stretches (by name, body part, or tag).
/// With an empty query it lists everything — doubles as "browse all".
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ContentRepository.instance;
    final List<Stretch> results =
        _query.trim().isEmpty ? repo.stretches : repo.search(_query);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search stretches…',
            border: InputBorder.none,
            suffixIcon: _query.isEmpty
                ? null
                : IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      setState(() => _query = '');
                    },
                  ),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
      ),
      body: results.isEmpty
          ? _empty(context)
          : Column(
              children: [
                if (_query.trim().isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('All stretches (${results.length})',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: results.length,
                    itemBuilder: (context, i) => StretchTile(
                      stretch: results[i],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                StretchDetailScreen(stretch: results[i])),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _empty(BuildContext c) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off,
                  size: 56, color: Theme.of(c).colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text('No stretches found',
                  style: Theme.of(c).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Try a body part, a prop, or a different word.',
                textAlign: TextAlign.center,
                style: Theme.of(c).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(c).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
}
