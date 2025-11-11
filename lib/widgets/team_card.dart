import 'package:flutter/material.dart';
import '../features/player/data/player_model.dart';

class TeamCard extends StatelessWidget {
  final List<Player> team;
  final int index;
  const TeamCard({super.key, required this.team, required this.index});

  int get totalScore => team.fold(0, (s, p) => s + p.level);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time ${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Score: $totalScore',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Divider(),
            ...team.map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 8),
                    Text('${p.name} (Nível ${p.level})'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
