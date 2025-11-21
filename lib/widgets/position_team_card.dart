import 'package:flutter/material.dart';
import '../features/position/data/position_player_model.dart';
import '../features/position/logic/position_team_balancer.dart';

class PositionTeamCard extends StatelessWidget {
  final List<PositionPlayer> team;
  final int index;

  const PositionTeamCard({
    super.key,
    required this.team,
    required this.index,
  });

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
  Widget build(BuildContext context) {
    final stats = PositionTeamBalancer.getTeamStats(team);
    final positionCount = stats['positions'] as Map<VolleyballPosition, int>;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Time ${index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Nível Total: ${stats['totalLevel']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Resumo de posições
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: VolleyballPosition.values.map((pos) {
                final count = positionCount[pos] ?? 0;
                if (count == 0) return const SizedBox.shrink();

                return Chip(
                  avatar: Icon(
                    _getPositionIcon(pos),
                    size: 16,
                    color: _getPositionColor(pos),
                  ),
                  label: Text('${pos.label}: $count'),
                  backgroundColor: _getPositionColor(pos).withOpacity(0.1),
                );
              }).toList(),
            ),

            const Divider(height: 24),

            // Lista de jogadores
            if (team.isEmpty)
              const Text(
                "Nenhum jogador neste time",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              )
            else
              ...team.map((p) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        _getPositionIcon(p.position),
                        size: 20,
                        color: _getPositionColor(p.position),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Nv ${p.level}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
