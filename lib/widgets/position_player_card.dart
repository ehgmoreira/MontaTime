import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/position/data/position_player_model.dart';
import '../features/position/controllers/position_player_controller.dart';
import '../core/utils/level_utils.dart';

class PositionPlayerCard extends ConsumerWidget {
  final PositionPlayer player;
  const PositionPlayerCard({super.key, required this.player});

  IconData _getPositionIcon(VolleyballPosition position) {
    switch (position) {
      case VolleyballPosition.levantador:
        return Icons.front_hand;
      case VolleyballPosition.ponteiro:
        return Icons.sports_handball;
      case VolleyballPosition.oposto:
        return Icons.power;
      case VolleyballPosition.central:
        return Icons.height;
      case VolleyballPosition.libero:
        return Icons.shield;
    }
  }

  Color _getPositionColor(VolleyballPosition position) {
    switch (position) {
      case VolleyballPosition.levantador:
        return Colors.blue;
      case VolleyballPosition.ponteiro:
        return Colors.orange;
      case VolleyballPosition.oposto:
        return Colors.red;
      case VolleyballPosition.central:
        return Colors.green;
      case VolleyballPosition.libero:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getPositionColor(player.position).withOpacity(0.2),
          child: Icon(
            _getPositionIcon(player.position),
            color: _getPositionColor(player.position),
          ),
        ),
        title: Text(
          player.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${player.position.label} • ${levelLabel(player.level)}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () =>
              ref.read(positionPlayersProvider.notifier).remove(player.id),
        ),
      ),
    );
  }
}
