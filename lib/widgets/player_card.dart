import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/player/data/player_model.dart';
import '../features/player/controllers/player_controller.dart';
import '../core/utils/level_utils.dart';

class PlayerCard extends ConsumerWidget {
  final Player player;
  const PlayerCard({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
          ),
        ),
        title: Text(
          player.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(levelLabel(player.level)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => ref.read(playersProvider.notifier).remove(player.id),
        ),
      ),
    );
  }
}
