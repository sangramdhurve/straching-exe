import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/constants/app_constants.dart';
import '../../data/content_repository.dart';
import '../../models/stretch.dart';
import '../../widgets/stretch_tile.dart';
import '../stretch/stretch_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListenableBuilder(
        listenable: AppState.instance,
        builder: (context, _) {
          final repo = ContentRepository.instance;
          final favs = AppState.instance.favorites
              .map((id) => repo.byId(id))
              .whereType<Stretch>()
              .toList();
          if (favs.isEmpty) return _empty(context);
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: favs.length,
            itemBuilder: (context, i) => StretchTile(
              stretch: favs[i],
              isFavorite: true,
              onFavorite: () => AppState.instance.toggleFavorite(favs[i].id),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => StretchDetailScreen(stretch: favs[i])),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _empty(BuildContext c) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.favorite_border,
                  size: 64, color: Theme.of(c).colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text('No favorites yet',
                  style: Theme.of(c).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Tap the heart on any stretch to save it here.',
                textAlign: TextAlign.center,
                style: Theme.of(c).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(c).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
}
